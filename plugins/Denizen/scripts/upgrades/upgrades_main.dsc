open_station:
    type: world
    debug: false
    events:
        on player right clicks lime_stained_glass_pane:
            - inventory open d:mh_upgrades_main


ii_player_upgrades:
    type: item
    display name: <&a>Player Upgrades
    debug: false
    material: player_head[skull_skin=<player.name>]
    lore:
        - <&7>Upgrades for the player
        - <&7>
        - <&e>CLICK TO OPEN

ii_hero_upgrades:
    type: item
    display name: <&a>Hero Upgrades
    debug: false
    material: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYWE5OWJmMTM3OWE0Y2MwYmEwMjE3ZTQ3MzViZTI4ZTY1NTQ4Y2M0M2IxZDM0MDczZGUyZGY4NmY5OTE2Mzg3MCJ9fX0=]
    lore:
        - <&7>Unlock new heroes and upgrades
        - <&7>
        - <&e>CLICK TO OPEN

mh_upgrades_gui_handler:
    type: world
    debug: false
    events:
        on player drags item_flagged:inv_ui:
            - determine passively cancelled
        on player clicks item_flagged:inv_ui in inventory:
            - determine passively cancelled
        on player clicks ii_player_upgrades in mh_upgrades_main:
            - inventory open d:mh_upgrades_players

        on player clicks !air in mh_upgrades_players:
            - stop if:<context.item.script.name.equals[pane_black]>
            - if <player.flag[<context.item.flag[upgrade]>].if_null[0]> >= <context.item.flag[max]>:
                - narrate "<&c>You cannot upgrade this any further!"
                - stop
            - if <player.flag[mh.gold]> >= <context.item.flag[cost]>:
                - flag <player> mh.gold:-:<context.item.flag[cost]>
                - if !<player.has_flag[<context.item.flag[upgrade]>]>:
                    - playsound sound:entity_player_levelup <player>
                    - flag <player> <context.item.flag[upgrade]>:1
                - flag <player> <context.item.flag[upgrade]>:+:1
                - narrate "<&8><&gt><&gt> <context.item.display><&a> is now level <player.flag[<context.item.flag[upgrade]>]>"
                - playsound sound:block_note_block_bit <player> pitch:1.<player.flag[<context.item.flag[upgrade]>].mod[10]>
                - inventory open d:mh_upgrades_players
            - else:
                - narrate "<&c>You cannot afford this upgrade!"

        on player clicks ii_hero_upgrades in mh_upgrades_main:
            - inventory open d:mh_upgrades_heroes
        on player clicks !air in mh_upgrades_heroes:
            - stop if:<context.item.script.name.equals[pane_black]>
            - if <player.flag[<context.item.flag[upgrade]>].if_null[0]> >= <context.item.flag[max]>:
                - narrate "<&c>You cannot upgrade this any further!"
                - stop
            - if <player.flag[mh.gold]> >= <context.item.flag[cost]>:
                - flag <player> mh.gold:-:<context.item.flag[cost]>
                - define abilities <context.item.flag[abilities]>
                - if !<player.has_flag[<context.item.flag[upgrade]>]>:
                    - playsound sound:entity_player_levelup <player>
                    - flag <player> <context.item.flag[upgrade]>:1
                - flag <player> <context.item.flag[upgrade]>:+:1
                - if <context.item.has_flag[subupgrade]>:
                    - flag <player> <context.item.flag[subupgrade]>:+:<context.item.flag[subupval]>
                - if <player.has_flag[mh.upgrades.dps_click]>:
                    - flag <player> mh.click_dmg:<player.flag[mh.click_dmg].add[<player.flag[mh.dps].mul[<player.flag[mh.upgrades.dps_click].div[10]>]>].round_up>
                - foreach <[abilities].reverse> key:b as:a:
                    - if <player.flag[<context.item.flag[upgrade]>]> >= <[b]>:
                        - if <player.flag[mh.upgrades.abilities].if_null[<list>].contains[<[a]>]>:
                            - foreach stop
                        - else:
                            - run <[a]>
                            - flag <player> mh.upgrades.abilities:->:<[a]>
                            - foreach stop

                - narrate "<&8><&gt><&gt> <context.item.display><&a> is now level <player.flag[<context.item.flag[upgrade]>]>"
                - playsound sound:block_note_block_bit <player> pitch:1.<player.flag[<context.item.flag[upgrade]>].mod[10]>
                - inventory open d:mh_upgrades_heroes
            - else:
                - narrate "<&c>You cannot afford this upgrade!"

mh_upgrades_main:
    type: inventory
    title: Upgrades
    debug: false
    inventory: chest
    size: 54
    gui: true
    definitions:
        p: pane_black
    slots:
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [p] [p] [ii_player_upgrades] [p] [ii_hero_upgrades] [p] [p] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]


ii_gold_magnet:
    type: item
    debug: false
    display name: <&6>Coins Magnet
    material: gold_ingot
    flags:
        cost: <proc[upgrade_formula].context[100|<player.flag[mh.upgrades.player.gold_magnet].if_null[1]>]>
        upgrade: mh.upgrades.player.gold_magnet
        max: 50
    lore:
        - <&7>Automatically picks up nearby coins
        - <&7>within <&a><player.flag[mh.upgrades.player.gold_magnet].if_null[1].div[5]><&7> blocks.
        - <&7>
        - <&8>Cost: <&6><proc[upgrade_formula].context[100|<player.flag[mh.upgrades.player.gold_magnet].if_null[1]>]> Coins
        - <&7>
        - <&7><player.has_flag[mh.upgrades.player.gold_magnet].if_true[<player.flag[mh.upgrades.player.gold_magnet].is_more_than_or_equal_to[50].if_true[<&2><&l>MAX LEVEL].if_false[<&2><&l>LEVEL<&sp><player.flag[mh.upgrades.player.gold_magnet]>]>].if_false[<&c><&l>NOT<&sp>UNLOCKED]>

gold_magnet_handler:
    type: task
    debug: false
    script:
        - define range <player.flag[mh.upgrades.player.gold_magnet].if_null[1].div[5]>
        - define ents <player.location.find_entities[dropped_item].within[<[range]>].filter_tag[<[filter_value].has_flag[value]>]>
        - teleport <[ents]> <player.location>



mh_upgrades_players:
    type: inventory
    title: Player Upgrades
    debug: false
    inventory: chest
    size: 54
    gui: true
    definitions:
        p: pane_black
    slots:
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [ii_gold_magnet] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]


ii_sid_hero:
    type: item
    material: player_head[skull_skin=ewogICJ0aW1lc3RhbXAiIDogMTY5ODM4OTY0MDU2NCwKICAicHJvZmlsZUlkIiA6ICI3MzE4MWQxZDRjYWQ0ZmU0YTcxNWNjNmUxOGNjYzVkNyIsCiAgInByb2ZpbGVOYW1lIiA6ICJaZmVybjRuZGl0b19SdyIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS81YjRjMGEzMjdkNDIxNWY2NmEyMWVmYmYzNjY5NGI1NTU5YjRlOTdiNmY3NWM1NGVmNThhZTEzZjRkNWI5ODU1IgogICAgfQogIH0KfQ==]
    display name: <&b>Sid, the Helpful Adventurer
    debug: false
    flags:
        cost: <proc[upgrade_formula].context[5|<player.flag[mh.upgrades.hero.sid].if_null[1]>]>
        upgrade: mh.upgrades.hero.sid
        subupgrade: mh.click_dmg
        subupval: <element[1].mul[<player.flag[mh.upgrades.hero.sid_multiplier].if_null[1]>]>
        max: 10000
        abilities:
            10: heroes_abilities.big_clicks
            25: heroes_abilities.a_minestorm
            50: heroes_abilities.huge_clicks
            75: heroes_abilities.massive_clicks
            100: heroes_abilities.titanic_clicks
            125: heroes_abilities.colossal_clicks
            150: heroes_abilities.monumental_clicks
    lore:
        - <&7>Your <&8>click damage<&7> will be <&a><player.flag[mh.click_dmg].if_null[0].add[<element[1].mul[<player.flag[mh.upgrades.hero.sid_multiplier].if_null[1]>]>]> <&7>after
        - <&7>the upgrade.
        - <&7   >
        - <&a>+<element[1].mul[<player.flag[mh.upgrades.hero.sid_multiplier].if_null[1]>]><&7> Damage next upgrade
        - <&7>
        - <&8>Cost: <&6><proc[upgrade_formula].context[5|<player.flag[mh.upgrades.hero.sid].if_null[1]>]> Coins
        - <&7>
        - <&7><player.has_flag[mh.upgrades.hero.sid].if_true[<player.flag[mh.upgrades.hero.sid].is_more_than_or_equal_to[10000].if_true[<&2><&l>MAX LEVEL].if_false[<&2><&l>LEVEL<&sp><player.flag[mh.upgrades.hero.sid]>]>].if_false[<&c><&l>NOT<&sp>UNLOCKED]>

ii_treedemon_hero:
    type: item
    material: player_head[skull_skin=ewogICJ0aW1lc3RhbXAiIDogMTU5MTE2NDE5MjU4NSwKICAicHJvZmlsZUlkIiA6ICJkNjBmMzQ3MzZhMTI0N2EyOWI4MmNjNzE1YjAwNDhkYiIsCiAgInByb2ZpbGVOYW1lIiA6ICJCSl9EYW5pZWwiLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvM2Y0ZWE3YWI0MzQzZGE2MjJjZGJjZjI3YzIxM2I5YzJiODBiMjE4MWMwMTBlNmUxMDQ3ZGM4Njc3OTgwODljMiIKICAgIH0KICB9Cn0=]
    display name: <&2>Treedemon
    debug: false
    flags:
        cost: <proc[upgrade_formula].context[50|<player.flag[mh.upgrades.hero.treedemon].if_null[1]>]>
        upgrade: mh.upgrades.hero.treedemon
        subupgrade: mh.dps
        subupval: <element[1].mul[<player.flag[mh.upgrades.hero.treedemon_multiplier].if_null[1]>]>
        max: 10000
        abilities:
            2: heroes_abilities.treedemon_base
            10: heroes_abilities.fertilizer
            25: heroes_abilities.thorns
            50: heroes_abilities.megastick
            75: heroes_abilities.ultrastick
            100: heroes_abilities.lacquer
    lore:
        - <&7>Your <&8>DPS<&7> will be <&a><player.has_flag[mh.upgrades.hero.treedemon].if_true[<player.flag[mh.dps].if_null[0].add[<element[1].mul[<player.flag[mh.upgrades.hero.treedemon_multiplier].if_null[1]>]>]>].if_false[5]> <&7>after
        - <&7>the upgrade.
        - <&7>
        - <&a>+<element[1].mul[<player.flag[mh.upgrades.hero.treedemon_multiplier].if_null[1]>]><&7> Damage next upgrade
        - <&7>
        - <&8>Cost: <&6><proc[upgrade_formula].context[50|<player.flag[mh.upgrades.hero.treedemon].if_null[1]>]> Coins
        - <&7>
        - <&7><player.has_flag[mh.upgrades.hero.treedemon].if_true[<player.flag[mh.upgrades.hero.treedemon].is_more_than_or_equal_to[10000].if_true[<&2><&l>MAX LEVEL].if_false[<&2><&l>LEVEL<&sp><player.flag[mh.upgrades.hero.treedemon]>]>].if_false[<&c><&l>NOT<&sp>UNLOCKED]>

ii_steven_hero:
    type: item
    material: player_head[skull_skin=ewogICJ0aW1lc3RhbXAiIDogMTY5ODYzNjM5Mzg0MywKICAicHJvZmlsZUlkIiA6ICI5MThhMDI5NTU5ZGQ0Y2U2YjE2ZjdhNWQ1M2VmYjQxMiIsCiAgInByb2ZpbGVOYW1lIiA6ICJCZWV2ZWxvcGVyIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2ExZWMzNjAyMjRkNjAzYmY0ODlhOTY3NjM1MGQxMzdkNWJjNjdiZjRiZWQ2NDA4ZGFlOGZhNGZmNjU4ZTM0MDUiCiAgICB9CiAgfQp9]
    display name: <&3>Steven, the Drunken Brawler
    debug: false
    flags:
        cost: <proc[upgrade_formula].context[250|<player.flag[mh.upgrades.hero.steven].if_null[1]>]>
        upgrade: mh.upgrades.hero.steven
        subupgrade: mh.dps
        subupval: <element[1].mul[<player.flag[mh.upgrades.hero.steven_multiplier].if_null[1]>]>
        max: 10000
        abilities:
            2: heroes_abilities.steven_base
            10: heroes_abilities.hard_cider
            25: heroes_abilities.ale
            50: heroes_abilities.pitcher
            75: heroes_abilities.a_powersurge
            100: heroes_abilities.embalming_fluid
            125: heroes_abilities.pig_whiskey
    lore:
        - <&7>Your <&8>DPS<&7> will be <&a><player.has_flag[mh.upgrades.hero.steven].if_true[<player.flag[mh.dps].if_null[0].add[<element[1].mul[<player.flag[mh.upgrades.hero.steven_multiplier].if_null[1]>]>]>].if_false[22]> <&7>after
        - <&7>the upgrade.
        - <&7>
        - <&a>+<element[1].mul[<player.flag[mh.upgrades.hero.steven_multiplier].if_null[1]>]><&7> Damage next upgrade
        - <&7>
        - <&8>Cost: <&6><proc[upgrade_formula].context[250|<player.flag[mh.upgrades.hero.steven].if_null[1]>]> Coins
        - <&7>
        - <&7><player.has_flag[mh.upgrades.hero.steven].if_true[<player.flag[mh.upgrades.hero.steven].is_more_than_or_equal_to[10000].if_true[<&2><&l>MAX LEVEL].if_false[<&2><&l>LEVEL<&sp><player.flag[mh.upgrades.hero.steven]>]>].if_false[<&c><&l>NOT<&sp>UNLOCKED]>




heroes_abilities:
    type: task
    debug: false
    script:
        - narrate Heroes
    pig_whiskey:
        - narrate "<&a>Unlocked <&e>Pint of Pig Whiskey<&a>!"
        - narrate "<&8><&gt><&7> Increases your <&8>Click Damage<&7> by <&a>0.5%<&7> of your total <&8>DPS<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.dps_click:+:0.5
    embalming_fluid:
        - narrate "<&a>Unlocked <&e>Embalming Fluid<&a>!"
        - narrate "<&8><&gt><&7> Increases Steven's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.steven_multiplier:4
    a_powersurge:
        - narrate "<&a>Unlocked <&6><&l>Powersurge<&a>!"
        - narrate "<&8><&gt><&7> Unlocks the <&6><&l>Powersurge<&7> skill.."
        - playsound sound:entity_player_levelup <player> pitch:1.5
    pitcher:
        - narrate "<&a>Unlocked <&e>Pitcher<&a>!"
        - narrate "<&8><&gt><&7> Increases Steven's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.steven_multiplier:4
    ale:
        - narrate "<&a>Unlocked <&e>Pint of Ale<&a>!"
        - narrate "<&8><&gt><&7> Increases Steven's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.steven_multiplier:4
    hard_cider:
        - narrate "<&a>Unlocked <&e>Hard Cider<&a>!"
        - narrate "<&8><&gt><&7> Increases Steven's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.steven_multiplier:2
    steven_base:
        - flag <player> mh.dps:+:21
    treedemon_base:
        - flag <player> mh.dps:+:4
    fertilizer:
        - narrate "<&a>Unlocked <&e>Fertilizer<&a>!"
        - narrate "<&8><&gt><&7> Increases Treedemon's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.treedemon_multiplier:2
    thorns:
        - narrate "<&a>Unlocked <&e>Thorns<&a>!"
        - narrate "<&8><&gt><&7> Increases Treedemon's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.treedemon_multiplier:3
    megastick:
        - narrate "<&a>Unlocked <&e>Mega-Stick<&a>!"
        - narrate "<&8><&gt><&7> Increases Treedemon's <&8>DPS<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.treedemon_multiplier:4
    ultrastick:
        - narrate "<&a>Unlocked <&e>Ultra-Stick<&a>!"
        - narrate "<&8><&gt><&7> Increases Treedemon's <&8>DPS<&7> by <&a>150%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.treedemon_multiplier:5
    lacquer:
        - narrate "<&a>Unlocked <&e>Lacquer<&a>!"
        - narrate "<&8><&gt><&7> Increases your <&8>Click Damage<&7> by <&a>0.5%<&7> of your total <&8>DPS<&7>."
        - playsound sound:entity_player_levelup <player> pitch:1
        - flag <player> mh.upgrades.dps_click:+:0.5
    big_clicks:
        - narrate "<&a>Unlocked <&e>Big Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:2
    a_minestorm:
        - narrate "<&a>Unlocked <&6><&l>Minestorm<&a>!"
        - narrate "<&8><&gt><&7> Unlocks the <&6><&l>Minestorm<&7> skill.."
        - playsound sound:entity_player_levelup <player> pitch:1.5

    huge_clicks:
        - narrate "<&a>Unlocked <&e>Huge Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:4
    massive_clicks:
        - narrate "<&a>Unlocked <&e>Massive Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>100%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:6
    titanic_clicks:
        - narrate "<&a>Unlocked <&e>Titanic Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>150%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:8
    colossal_clicks:
        - narrate "<&a>Unlocked <&e>Colossal Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>200%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:11
    monumental_clicks:
        - narrate "<&a>Unlocked <&e>Monumental Clicks<&a>!"
        - narrate "<&8><&gt><&7> Increases Sid's <&8>Click damage<&7> by <&a>250%<&7>."
        - playsound sound:entity_player_levelup <player>
        - flag <player> mh.upgrades.hero.sid_multiplier:+:15

mh_upgrades_heroes:
    type: inventory
    title: Hero Upgrades
    debug: false
    inventory: chest
    size: 54
    gui: true
    definitions:
        p: pane_black
    slots:
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [ii_sid_hero] [ii_treedemon_hero] [ii_steven_hero] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]