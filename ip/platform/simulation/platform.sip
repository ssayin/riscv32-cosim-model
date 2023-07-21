set_global_assignment -entity "platform" -library "lib_platform" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "platform" -library "lib_platform" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "platform" -library "lib_platform" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_platform" -name SPD_FILE [file join $::quartus(sip_path) "../platform.spd"]
set_global_assignment -library "lib_platform" -name MISC_FILE [file join $::quartus(sip_path) "../../../platform.qsys"]

set_global_assignment -library "lib_platform" -name MISC_FILE [file join $::quartus(sip_path) "platform.v"]
