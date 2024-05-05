update_checker:
    type: task
    debug: false
    script:
        - definemap flags:
            - mh
            - mh.zone:oak_forest
            - mh.level:1
            - mh.dps:0


first_joins:
    type: world
    debug: false
    events:
        after player joins flagged:!mh:
            - flag <player> mh
            - flag <player> mh.zone:oak_forest
            - flag <player> mh.level:1
            - flag <player> mh.dps:0
            - flag <player> mh.click_dmg:1
            - flag <player> mh.gold:0
            - flag <player> mh.kill_req:0
            - run world_creator
            - inventory set o:ii_skills_menu_item slot:8
            - inventory set o:ii_main_menu_item slot:9
            - adjust <player> hide_particles:sweep_attack
            - adjust <player> hide_particles:damage_indicator
            - adjust <player> hide_particles:crit
            - definemap attributes:
                generic_attack_speed:
                    1:
                        operation: ADD_NUMBER
                        amount: 25
                        slot: hand
            - adjust <player> attribute_modifiers:<[attributes]>
        after player joins flagged:mh:
            - inventory set o:ii_skills_menu_item slot:8
            - inventory set o:ii_main_menu_item slot:9
            - adjust <player> hide_particles:sweep_attack
            - adjust <player> hide_particles:damage_indicator
            - adjust <player> hide_particles:crit
            - definemap attributes:
                generic_attack_speed:
                    1:
                        operation: ADD_NUMBER
                        amount: 25
                        slot: hand
            - adjust <player> attribute_modifiers:<[attributes]>
            - createworld mineheroes_defaultworld_<player.uuid>
            - teleport <player> <world[mineheroes_defaultworld_<player.uuid>].spawn_location>
