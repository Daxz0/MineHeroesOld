upgrade_formula:
    type: procedure
    debug: false
    definitions: base|level
    script:
        - define pr <element[1.07].power[<[level].sub[1]>]>
        - determine <[base].mul[<[pr]>].round_up>

damage:
    type: procedure
    debug: false
    definitions: base|level
    script:
        - define pr <element[1.07].power[<[level].sub[1]>]>
        - determine <[base].mul[<[pr]>].round_up>