ii_skills_menu_item:
    type: item
    debug: false
    material: diamond
    display name: <&8>Skills Menu
    flags:
        inv_ui: true
    lore:
        - <&7>Access the skills for your heroes.


mh_skills_menu:
    type: inventory
    title: Skills
    debug: false
    inventory: chest
    size: 54
    gui: true
    definitions:
        p: pane_black
    procedural items:
        - define output <list>
        - definemap items:
            minestorm:
                item: fire_charge
                lore: <list[<&7>Activates a temporary Auto Clicker|<&7>which automatically performs <&a>10<&7>|<&7>clicks per second for <&a>30s<&7>]>
                cooldown: 5m
            powersurge:
                item: potion
                lore: <list[<&a>+100%<&8> DPS<&7> for <&a>30<&7> seconds.]>
                cooldown: 5m
        - define list <player.flag[mh.upgrades.abilities].filter_tag[<[filter_value].advanced_matches[heroes_abilities.a_*]>].parse_tag[<[parse_value].replace_text[heroes_abilities.a_].with[]>]>
        # - foreach <[list]> as:l:
        #     - define mat <[items].get[<[name]>].get[item]>
        #     - define lor <[items].get[<[name]>].get[lore]>
        #     - define item <item[<[mat]>].with[display=<&6><&l><[name].to_titlecase>].with[lore=<[lor]>].with_flag[ability:<[name]>].with_flag[cooldown:5m]>
        #     - define output:->:<[item]>
        - foreach <[items]> key:a as:l:
            - if <[list].contains[<[a]>]>:
                - define mat <[l].get[item]>
                - define lor <[l].get[lore]>
                - define item <item[<[mat]>].with[display=<&6><&l><[a].to_titlecase>].with[lore=<[lor]>].with_flag[ability:<[a]>].with_flag[cooldown:5m]>
                - define output:->:<[item]>
            - else:
                - define item <item[barrier].with[display=<&c><&l>[NOT<&sp>UNLOCKED]].with[lore=<&4><&gt><&k> <[a]>]>
                - define output:->:<[item]>

        - determine <[output]>
    slots:
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]


skills_handlers:
    type: world
    debug: false
    events:
        on player right clicks block with:ii_skills_menu_item:
            - inventory open d:mh_skills_menu
        on player clicks !air in mh_skills_menu:
            - stop if:<context.item.script.name.equals[pane_black].if_null[false]>
            - stop if:<context.item.material.name.equals[barrier]>
            - define list <player.flag[mh.upgrades.abilities].filter_tag[<[filter_value].advanced_matches[heroes_abilities.a_*]>].parse_tag[<[parse_value].replace_text[heroes_abilities.a_].with[]>]>
            - inventory close
            - if <player.has_flag[mh.abilities.cooldown.<context.item.flag[ability].as[element]>]>:
                - narrate "<&c><context.item.flag[ability].as[element].to_titlecase> is on cooldown for <&l><player.flag_expiration[mh.abilities.cooldown.<context.item.flag[ability].as[element]>].from_now.formatted><&c>!"
                - stop
            - run skills_handlers.<context.item.flag[ability].as[element]>
            - flag <player> mh.abilities.cooldown.<context.item.flag[ability].as[element]> expire:<context.item.flag[cooldown].as[element]>
            - narrate "<context.item.display><&7> has been activated!"
    minestorm:
        - repeat 120:
            - repeat next if:!<player.is_online>
            - define loc <script[monster_data].data_key[<player.flag[mh.zone]>.spawn_location].parsed>
            - define cuboid <cuboid[<player.location.world.name>,<[loc].left[0.5].backward_flat[0.5].above[2].xyz>,<[loc].right[0.5].forward_flat[0.5].above[4].xyz>]>
            - define p1 <[loc]>
            - define p2 <[cuboid].random>
            - playeffect effect:redstone special_data:1|<list[#ebe134|#e6e070].random> at:<[p1].points_between[<[p2]>].distance[0.1]> offset:0.1 quantity:2
            - playeffect effect:end_rod at:<[p1].points_between[<[p2]>].distance[0.1]> offset:0.15 quantity:1
            - playeffect effect:glow at:<[p1].points_between[<[p2]>].distance[0.1]> offset:0.1 quantity:2
            - playsound sound:entity_silverfish_death <[loc]> pitch:2
            - playsound sound:item_trident_throw <[loc]> pitch:1
            - hurt <player.flag[mh.click_dmg]> <[loc].find_entities[slime].within[1]> source:<player>
            - wait 5t
    powersurge:
        - flag <player> mh.dps_multiplier:+:2
        - wait 30s
        - flag <player> mh.dps_multiplier:-:2
        - if <player.flag[mh.dps_multiplier]> == 0:
            - flag <player> mh.dps_multiplier:!
