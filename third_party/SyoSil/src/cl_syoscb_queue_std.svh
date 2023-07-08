//----------------------------------------------------------------------
//   Copyright 2014-2015 SyoSil ApS
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
/// Standard implementation of a queue. Uses a normal SystemVerilog queue as
/// implementation. The class implements the queue API as defined by the queue
/// base class.
class cl_syoscb_queue_std extends cl_syoscb_queue;
  //-------------------------------------
  // Non randomizable variables
  //-------------------------------------
  /// Poor mans queue implementation as a SV queue
  local cl_syoscb_item items[$];

  //-------------------------------------
  // UVM Macros
  //-------------------------------------
  `uvm_component_utils_begin(cl_syoscb_queue_std)
    `uvm_field_queue_object(items, UVM_DEFAULT)
  `uvm_component_utils_end

  //-------------------------------------
  // Constructor
  //-------------------------------------
  extern function new(string name, uvm_component parent);

  //-------------------------------------
  // Queue API
  //-------------------------------------
  // Basic queue functions
  extern virtual function bit add_item(string producer, uvm_sequence_item item);
  extern virtual function bit delete_item(int unsigned idx);
  extern virtual function cl_syoscb_item get_item(int unsigned idx);
  extern virtual function int unsigned get_size();
  extern virtual function bit empty();
  extern virtual function bit insert_item(string producer, uvm_sequence_item item, int unsigned idx);

  // Iterator support functions
  extern virtual function cl_syoscb_queue_iterator_base create_iterator();
  extern virtual function bit delete_iterator(cl_syoscb_queue_iterator_base iterator);
endclass: cl_syoscb_queue_std

function cl_syoscb_queue_std::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function bit cl_syoscb_queue_std::add_item(string producer, uvm_sequence_item item);
  cl_syoscb_item new_item;

  // Check that the max_queue_size for this queue is not reached
  if(this.cfg.get_max_queue_size(this.get_name())>0 &&
     this.get_size()==this.cfg.get_max_queue_size(this.get_name())) begin
    `uvm_error("QUEUE_ERROR", $sformatf("Maximum number of items (%0d) for queue: %s reached",
                                       this.cfg.get_max_queue_size(this.get_name()),
                                       this.get_name()))
    return(1'b0);
  end

  // Create the new scoreboard item with META data which wraps the
  // uvm_sequence_item
  //
  // *NOTE*: No need for using create.
  //         New is okay since no customization is needed here
  //
  // *NOTE*: Create it once with a default name to be able to retrieve the unique
  //         instance id and then rename the object with a uniqueue name
  new_item = new(.name("default-item"));
  new_item.set_name({producer,"-item-", $psprintf("%0d", new_item.get_inst_id())});

  // Transfer the producer to the item
  // *NOTE*: No need to check the producer since this is checked by the parent component
  new_item.set_producer(.producer(producer));

  // Transfer the UVM sequence item to the item
  // *NOTE*: No need to copy it since it has been copied by the parent
  new_item.set_item(.item(item));

  // Insert the item in the queue
  this.items.push_back(new_item);

  // Signal that it worked
  return 1;
endfunction: add_item

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function bit cl_syoscb_queue_std::delete_item(int unsigned idx);
  if(idx < this.items.size()) begin
    cl_syoscb_queue_iterator_base iter[$];

    // Wait to get exclusive access to the queue
    // if there are multiple iterators
    while(!this.iter_sem.try_get());
    items.delete(idx);

    // Update iterators
    iter = this.iterators.find(x) with (x.get_idx() < idx);
    for(int i = 0; i < iter.size(); i++) begin
      void'(iter[i].previous());
    end

    this.iter_sem.put();
    return 1;
  end else begin
    `uvm_info("OUT_OF_BOUNDS", $sformatf("Idx: %0d is not present in queue: %0s", idx, this.get_name()), UVM_DEBUG);
    return 0;
  end
endfunction: delete_item

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function cl_syoscb_item cl_syoscb_queue_std::get_item(int unsigned idx);
  if(idx < this.items.size()) begin
    return items[idx];
  end else begin
    `uvm_info("OUT_OF_BOUNDS", $sformatf("Idx: %0d is not present in queue: %0s", idx, this.get_name()), UVM_DEBUG);
    return null;
  end
endfunction: get_item

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function int unsigned cl_syoscb_queue_std::get_size();
  return this.items.size();
endfunction: get_size

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function bit cl_syoscb_queue_std::empty();
  return(this.get_size()!=0 ? 0 : 1);
endfunction

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function bit cl_syoscb_queue_std::insert_item(string producer, uvm_sequence_item item, int unsigned idx);
  cl_syoscb_item new_item;

  // Create the new scoreboard item with META data which wraps the
  // uvm_sequence_item
  //
  // *NOTE*: No need for using create.
  //         New is okay since no customization is needed here
  //
  // *NOTE*: Create it once with a default name to be able to retrieve the unique
  //         instance id and then rename the object with a uniqueue name
  new_item = new(.name("default-item"));
  new_item.set_name({producer,"-item-", $psprintf("%0d", new_item.get_inst_id())});

  // Transfer the producer to the item
  // *NOTE*: No need to check the producer since this is checked by the parent component
  new_item.set_producer(.producer(producer));

  // Transfer the UVM sequence item to the item
  // *NOTE*: No need to copy it since it has been copied by the parent
  new_item.set_item(.item(item));

  if(idx < this.items.size()) begin
    cl_syoscb_queue_iterator_base iter[$];

    // Wait to get exclusive access to the queue
    // if there are multiple iterators
    while(!this.iter_sem.try_get());
    this.items.insert(idx, new_item);

    // Update iterators
    iter = this.iterators.find(x) with (x.get_idx() >= idx);
    for(int i = 0; i < iter.size(); i++) begin
      // Call .next() blindly. This can never fail by design, since
      // if it was point at the last element then it points to the second last
      // element prior to the .next(). The .next() call will then just
      // set the iterator to the correct index again after the insertion
      void'(iter[i].next());
    end

    this.iter_sem.put();
    return 1;
  end else if(idx == this.items.size()) begin
    this.items.push_back(new_item);
    return 1;
  end else begin
    `uvm_info("OUT_OF_BOUNDS", $sformatf("Idx: %0d too large for queue %0s", idx, this.get_name()), UVM_DEBUG);
    return 0;
  end
endfunction: insert_item


/// <b>Queue API:</b> See cl_syoscb_queue for more details
function cl_syoscb_queue_iterator_base cl_syoscb_queue_std::create_iterator();
  cl_syoscb_queue_iterator_std result;

  // Wait to get exclusive access to the queue
  // if there are multiple iterators
  while(this.iter_sem.try_get() == 0);

  result = cl_syoscb_queue_iterator_std::type_id::create(
  		$sformatf("%s_iter%0d", this.get_name(), this.iter_idx));

  // No need to check return value since set_queue will issue
  // and `uvm_error of something goes wrong
  void'(result.set_queue(this));

  this.iterators[result] = result;
  this.iter_idx++;
  this.iter_sem.put();

  return result;
endfunction: create_iterator

/// <b>Queue API:</b> See cl_syoscb_queue for more details
function bit cl_syoscb_queue_std::delete_iterator(cl_syoscb_queue_iterator_base iterator);
  if(iterator == null) begin
    `uvm_info("NULL", $sformatf("Asked to delete null iterator from list of iterators in %s",
                                this.get_name()), UVM_DEBUG);
    return 0;
  end else begin 	
    // Wait to get exclusive access to the queue
    // if there are multiple iterators
    while(!this.iter_sem.try_get());

    this.iterators.delete(iterator);
    this.iter_idx--;
    this.iter_sem.put();
    return 1;
  end
endfunction: delete_iterator
