
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name project1 -dir "/home/aula/Documentos/lucas/LUCAS_MICRO_2026/LAB2/project1/planAhead_run_2" -part xc3s1200efg320-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/aula/Documentos/lucas/LUCAS_MICRO_2026/LAB2/project1/decod_bcd.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/aula/Documentos/lucas/LUCAS_MICRO_2026/LAB2/project1} }
set_property target_constrs_file "pins.ucf" [current_fileset -constrset]
add_files [list {pins.ucf}] -fileset [get_property constrset [current_run]]
link_design
