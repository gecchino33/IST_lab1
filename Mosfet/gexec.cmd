# project name
name Mosfet
# execution graph
job 1   -post {  extract_vars "$wdir" n1_fps.out 1; catch {os_cp "$wdir/n1_mdr.cmd" "$wdir/n1_msh.cmd"}; catch {os_cp "$wdir/n1_mdr.bnd" "$wdir/n1_msh.bnd"} }  -o n1_fps "sprocess -u n1_fps.cmd"
check sprocess_fps.cmd 1793960192
check global_tooldb 1648737506
check gtree.dat 1793953995
# included files
