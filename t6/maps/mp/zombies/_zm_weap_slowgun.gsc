�GSC
     �  �)  �  �)  _#  �$  ?2  ?2  �  @ � ! T        ./_zm_weap_slowgun.gsc init int slowgun_fx actor  registerclientfield float anim_rate allplayers sndParalyzerLoop toplayer sliquifier_distance_checks slowgun_on_zombie_spawned maps/mp/zombies/_zm_spawner add_cusom_zombie_spawn_logic slowgun_zombie_damage_response register_zombie_damage_callback slowgun_zombie_death_response register_zombie_death_animscript_callback weapon/paralyzer/fx_paralyzer_body_disintegrate loadfx zombie_slowgun_explosion _effect weapon/paralyzer/fx_paralyzer_body_disintegrate_ug zombie_slowgun_explosion_ug weapon/paralyzer/fx_paralyzer_hit_dmg zombie_slowgun_sizzle weapon/paralyzer/fx_paralyzer_hit_dmg_ug zombie_slowgun_sizzle_ug weapon/paralyzer/fx_paralyzer_hit_noharm player_slowgun_sizzle player_slowgun_sizzle_ug weapon/paralyzer/fx_paralyzer_hit_noharm_view player_slowgun_sizzle_1st slowgun_player_connect onplayerconnect_callback slowgun_damage slowgun_damage_ug MOD_PROJECTILE_SPLASH slowgun_damage_mod damage_heavy precacherumble watch_reset_anim_rate watch_slowgun_fired sndwatchforweapswitch weapon disconnect weapon_change slowgun_zm slowgun_upgraded_zm setclientfieldtoplayer set_anim_rate respawned player_suicide player_revived entering_last_stand spawned waittill_any spawned_player weapon_fired slowgun_fired upgraded origin forward targets target _k1 _a1 dot getweaponmuzzlepoint getweaponforwarddir get_targets_in_range isplayer is_player_valid player_paralyzed paralyzer_hit_callback zombie_paralyzed vectordot slowgun_get_enemies_in_range position possible_targets inner_range outer_range cylinder_radius view_pos slowgun_inner_range_squared slowgun_outer_range_squared cylinder_radius_squared forward_view_angles end_pos i test_origin test_range_squared normal radial_origin slowgun_enemies isalive getcentroid distancesquared range slowgun_debug_print vectornormalize pointonsegmentnearesttopoint cylinder damageconetrace cone slowgun_targets slowgun_target_time all zombie_team getaispeciesarray get_players arraycombine possible_slowgun_targets paralyzer_damaged_multiplier paralyzer_score_time_ms paralyzer_slowtime setclientfield can_be_paralyzed zombie is_ghost is_true guts_explosion health rate qrate slowgun_anim_rate ignore_slowgun_anim_rates getclientfield setentityanimrate reset_anim animstate substate wait_network_frame is_traversing getanimstatefromasd no_restart _no_restart getanimsubstatefromasd setanimstatefromasd needs_run_update zombie_change_rate time newrate zombie_slow_for_time multiplier paralyzer_time_per_frame new_rate slowgun_desired_anim_rate slowing preserve_asd_substates wpn_paralyzer_slowed_loop playloopsound max stoploopsound player insta damage maps/mp/zombies/_zm_powerups is_insta_kill_active randomfloatrange paralyzer_damage none dodamage min get_extra_damage amount mod slow mult hit_location hit_origin extra_damage damageweapon damagemod is_slowgun_damage isdog maps/mp/zombies/_zm_score player_add_points explosion_choke slowgun_explosion_time slowgun_explosion_count explode_into_dust marked_for_insta_upgraded_death ghost attacker damagelocation zombie_death_points setjumpenabled onoff jump_was_enabled allowjump get_ahead_ent velocity start end mins maxs trace getvelocity lengthsquared geteyeapprox physicstracemaskclip physicstrace entity fraction surfacetype bump playrumbleonentity earthquake player_fly_rumble last_ground last_ahead ground ahead chance player_slow_stop_flying platform_collapse slowgun_flying getgroundent dont_tread_on_z zmb_invis_barrier_hit playsoundtoplayer invisible_collision get_response_chance randomintrange general maps/mp/zombies/_zm_audio create_and_play_dialog first_ground ghost_head_damage team score player_slow_for_time byplayer sizzle death slowgun_allow_player_paralyze J_SpineLower playfxontag msg color show_anim_rate pos dsquared show_slow_time show_anim_rates show_muzzle maps/mp/zombies/_zm_weapons maps/mp/zombies/_zm_utility maps/mp/_utility common_scripts/utility !  o  �
  �   /  K  g  x       &-
    �.
   
   .       6-
    X
   
   .       6-
    X
   
   .       6-
    �.
   
   .       6-
    �.
   
   .       6!  (-       .       6-     .       6-     .       6-
   .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-    .       6(!   (<!   (
  !  (-
   .     6       &-4        6-4        6-4        6         
   W; D 
   U$ % 
  F>  
   F;% -
  0        6
  U%-
  0      6?��        &-	   �?0      6-
  0        6;B -
  
   
   
   
   0        6-
  0        6-	   �?0      6?��          
   W
   U%
  U$ % 
  F; -0      6?  
   F; -0     6?��                        -0       '(-0      '(-0        '(S; � '(p'(_; t '(-.        ; ( -.        =  G;  -4     6?) 7   _; -7   56? -4     6q'(?��-^.      ' ( 	  ��L?I; -4      6                                             '(�'(0'(!   ('(_<    P'
(P'	(P'('(`N'('(SH;_9> -.       9; ? � -0     '(-.       '(	I;  -^ 
  0        6?� -O.     '(-.       '(I; -^ 
  0      6?z -.        ' (- .       I; -^ 
  0      6?> -0     F; -^ 
  0        6?     S!   ('A?��                       _9> 
 g    O�I; y '(-
     .       ' (--.        .     ' (    _=    SI; -    .       ' (- .        '(!   (g!  (         &-	   �?0      6      !  (!   (g!  (!  (-
  0        6         - 7    .       ;  - 7    .     ;   _=  7   I;             _; m !  (-   .       9= -    .     9;E -
  0        6-
   0        ' (- 0        6    _; -   16           -.        6_<  -   .       ; H -0     '(-   .       <  !  (
  N'(-0     ' (- 0      6? !  (X
   V          - 0     6    _; -   5 6? -4       6I; +             _< 	      @'(	���=	     �?NP'(    J; N!   (?    N!   (    _< !  (    _< !  (    	 ���>I;    	   ��L>O!   (? 	 ��L=!  (-   .     ;   !   (!   (-	 ���=
   0      6    I=  -.     ; �   	   ���=H;
 !  (?�    	   ���=PH;  -	��L?   .       !  (?�    	 ���=PH;  -	��?   .       !  (?U    	 ���=PH;  -	���>   .       !  (?)    	 ���=PH;  -	��L>   .       !  (       F;    	 ���=O!   (	���=+?�       K;\    ' (       O	  ��L>I;    	   ��L>N' (   	   ���=O!   (- 	 ���=.       6!   (?]       J;Q    ' (       O	  ��L>I;    	   ��L>O' (   	     �>O!   (- 	   �>.       6?1�   H; -0        6!  (!  (!   (-
  0        6-	 ���=0      6               -.       <   -0       '(; -
  0        6? -
  0        6    	 ���=J> =     	    ?J;� ; 
    ' (?    ' ( -	   �?	   ��*?.       P' (    P' (   _< !   (     �I;   �   QP' (     N!   (;     �N' (-.     ; % -
      
   7    0        6    	 33�?P!   (-2   .     !  (? !  (-	   ��L>0      6               	   �?O' (P                -       0      < }    _=    	     �?H=    G;Y -    .       ' ( I;= -.       ;  -
       0      6-.        <  g   O�K;/ g!   (     �H; -       
   0     6-0       ;      �N'(-.     ;  -
  0     6    &    _< !   (    gG;  !   (g!  (    I;$ 	   ��L=+    gG;  !   (g!  (?��!  A              _;  -.       6 ; -
  0      6? -
  0        6!   (-0        6       &-      0        <  -            0      6-   
   F    4      6         _=  
   F>  
   F         ; .    _; -    0      6"   ?  -0     6?    _< -0        !  (                   -0       '(-.     �H; -0     '(	  �>PN'(^ '(^ '(-   	    pA^(`	  pA^`.        ' (
   _;  
    ? " 
    	  �p}?H> 
    
  G;       &-
   0        6-�   	 ��>	      ?.       6                 
   W
   W
   W!  (-0        '('(;� -0     '(__G>  G; _;	 -0     6_=     9;
 -4     6 '(_;  '(? x -0       '(_; _ __G> G;M -
   0        6-
   .     ' ( -d.     I; -
  
   4      6-0        6'(	 ��>+?�               _< !  (-0        '(_=  7   _= 7      F;� ' (_9> 7   _= 7      F;� -    .       ;   _; h -7       0        6-7   .       ; 9    	     �?P!   (     �I;     �O!   (? !   (? -  7       0        6	    �>+-0        '(?-�        X
  V
   W
   W-    .       < 	 -4     6-
   0      6-	 ��L=0      6 +-	    �?0      6-
  0        6!  (           X
  V
   W
   W   _; -   1 <   G;7 
   ' (; 
   ' (     _;  -
       .        6-	   �>4      6                                         &                �  W       @  u      l  5      �        8  !      �       �  �     0  �     �  �          i     l  �     �   	      p  �	     �  �	     �  �        �
     @  )     d  �      �  �     $  h      x  W     �  >     �  n      �        �  '      !  �      $"  |     �"  �     (#  ;     4#  �     @#       P#        X#  # r q  �  �       8  � q   H  �  P  )q   Z  H�  `  hq   j  ��  p  �q  ~  �  �  �  �  �  �  uq     �q    �q  2  q   C  !q   O  5q   [  �q  �  �  �    ]"  �"  �q  �  %  �  z  m"  �"  �q    q  ]  v  ]q   �  rq   �  �q  �  �q  �  �q  �  �q    u  �q  B  �q  Y  |  q    �  �  �  �  :  q   .  %q  <  �  ;q  [  �  �  �  Oq  n  _q  �  �q  �  �q  `  �q   p  �q  z  �  �q  �  �q   �  Zq    �  �  �  �  �  �  �q 
 ,  B  �  �    $  Z  p!  �!  @"  �q  �  �q  �  	q   �  ?	q     j	q   B  �	q  Q   	q   �  [
q  �  i
q  �    0  \  �	q  �  L  �	q  g  m
q  �  iq  �  �
�
  �     �
q  H  �
q  �  �  V  �
q  �  �	q    Wq  Y  /  �
q  �  �o   �q   �  q     *�  Q  �q  i  dq  �  �  �  �q     �q    �q   "  �q  _  	q  �  q  �  �q      "   !  "  q   F   �   �q   ^   nq   |   �q  �   �q  �   
q  �   ;! �   �
q  �!  �!  'q   N"  �q  #  |q  #  \  �    (  `  �  2  �      �  �  �  �  �  Z"  �"  k  �  �  �  �  �  �  �  �  �  �  �  �  �    �  �  �    6  � D  � |  � �   	�  �  �  �  �  �    �"  #   �  ; �  W �  } �  � �  � �  � �  �  � �  �"   �  �"  - �  [ �  �  2  �"  (  � &  �*  �  �  �  � 0  �  Kn  :  |  R r  >  �  6"  ] ~  �  k �  T  �  �  F  �  v �  l  `  �  � �  � �  � �  � �  �      D   J  *�  �  2  �  �  �"  3�  �  N  �  �!  �!  Z#  :�  �  6  \#  B�  8  J�  Q�  U�  Y�  �  �$  4  �  �  4  �  :  .�  :�  F�  V�  _�  {�  ��  ��  ��  ��  ��  ��  ��  ��  �  �      &  5 T  Y �  | �  � �  �>  �  �  �J  �  � Z  �^    @!  d!  ��  �  �  	�  �  �  X  �  �  �  �    /   �  �  G  �  �  �    �  �  �  �    B  x  �  �  �  2  @  z"  �*  �!  �@    �X  �  .  �n  �p  �|      p  �  �  �  �    "  Z       f  n  �  ��  �  ��  �  	�  	�  1	  S	"  4  ^	 :  �	`  �	 f  �	r  �  &"  �	t   	�  �  �	�  �	�  �	�  
  "  (  6  D  R  �  �  �      .  :  Z  f  l  �  �  �  �      "
X  j  z  *
r  t  A
 ~  {
�  H  �  �
�  F#  �
�  �
`  j  p  �  �  �  �  �
 �  �  "  J  $  B  z  &  (  D  (F  3L  @R  (  \  MV  ,  J  i
  �
   �h  r  x  �  �  �  ��  �  �  �  ��  B  f  F  M�  S�  �  �  �  �  |�  ��  ��  ��  ��  �   �F  � l  x  � �  � �  9�  E�  P�  !  W�  ]�  d �  | �  �   V   n!  >"  �"  � �   � �   �    �   R!  _!  !  �!  �!  �!  �!  q2!  <!  V!  `!  v�!  �!  �!  �!  | *"  0"  ��"  ��"  � �"  �"  � �"  ��"  �"  � �"  �*#  �,#  �6#  B#  �8#  D#  