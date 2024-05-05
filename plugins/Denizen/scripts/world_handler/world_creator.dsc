world_creator:
    type: task
    debug: false
    script:
        - debug log "CREATING WORLD"
        - ~createworld mineheroes_defaultworld_<player.uuid> copy_from:mineheroes_defaultworld
        - debug log "WORLD CREATED"
        - teleport <player> <world[mineheroes_defaultworld_<player.uuid>].spawn_location>
        - run spawn_monster def:oak_forest
world_enter:
    type: task
    debug: false
    script:
        - createworld mineheroes_defaultworld
        - teleport <player> <world[mineheroes_defaultworld].spawn_location>