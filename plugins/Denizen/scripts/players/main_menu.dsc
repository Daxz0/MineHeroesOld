ii_main_menu_item:
    type: item
    debug: false
    material: nether_star
    display name: <&8>Main Menu
    flags:
        inv_ui: true
    lore:
        - <&7>Access the main menu.


mh_main_menu:
    type: inventory
    title: Main Menu
    debug: false
    inventory: chest
    size: 54
    gui: true
    definitions:
        p: pane_black
    slots:
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [] [] [] [] [] [] [] [p]
        - [p] [p] [p] [p] [p] [p] [p] [p] [p]


main_menu_handlers:
    type: world
    debug: false
    events:
        on player right clicks block with:ii_main_menu_item:
            - inventory open d:mh_main_menu