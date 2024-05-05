coins:
    type: item
    debug: false
    display name: <&6>Coins
    material: raw_gold

gold_splatter:
    type: task
    debug: false
    definitions: loc|value
    script:
        - if <[value]> < 5:
            - drop coins quantity:1 <[loc]> speed:1.5 save:gold
            - flag <entry[gold].dropped_entity> value:<[value]>
        - else:
            - repeat 5 as:b:
                - drop coins quantity:1 <[loc]> speed:1.5 save:gold
                - flag <entry[gold].dropped_entity> value:<[value].div[5].round_up>

gold_handlers:
    type: world
    debug: false
    events:
        on player picks up coins:
            - determine passively ITEM:AIR
            - repeat <context.item.quantity>:
                - playsound sound:entity_experience_orb_pickup <player> pitch:2
                - flag <player> mh.gold:+:<context.entity.flag[value]>
                - run sidebar_update

gold_worth_proc:
    type: procedure
    debug: false
    definitions: health
    script:
        - determine <[health].div[15].round_up>
