
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name project -dir "/home/lucas/Downloads/outros/faculdade/micro/LABS/LAB5/project/planAhead_run_2" -part xc3s1200efg320-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/lucas/Downloads/outros/faculdade/micro/LABS/LAB5/project/maquina_cafe_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/lucas/Downloads/outros/faculdade/micro/LABS/LAB5/project} }
set_property target_constrs_file "pins.ucf" [current_fileset -constrset]
add_files [list {pins.ucf}] -fileset [get_property constrset [current_run]]
link_design
