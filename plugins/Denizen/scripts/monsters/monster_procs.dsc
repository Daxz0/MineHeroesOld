health_proc:
    type: procedure
    debug: false
    definitions: level|isBoss
    script:
        - if !<[isBoss].exists>:
            - define isBoss false
        - define expo <element[1.55].power[<[level].sub[1]>]>
        - define pr <[level].sub[1].add[<[expo]>].mul[10]>
        - determine <[pr].round_down>