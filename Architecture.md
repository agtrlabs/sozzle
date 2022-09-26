graph TD
    SP[SplashPage]
    HO[HomePage]
    GA[GamePage]
    AC{{ApploaderCubit}}
    GC{{GamePlayBloc}}
    US{{UserProgressCubit}}
    LR[(LevelRepository)]
    UR[(UserProgressRepository)]
    
    SP-->HO
    HO-->GA
    AC-->|States|SP
    SP-->|Events|AC

    subgraph GamePlay
        LR-->|RepositoryProvider|GA
        GC-->|States|GA
        GA-->|Events|GC
        GA-->|Event - OnWin|US
    end

    AC--->LR
    AC--->UR
    US--->UR