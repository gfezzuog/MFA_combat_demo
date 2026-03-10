## Documentazione

- [Combat.tscn](#-combat.tscm)
- [Combat.gd](#-combat.gd)
- [Turn_Manager.gd](#-turn_manager.gd)
- [Action_Menu.tscn](#-action_menu.tscn)
- [Action_Menu.gd](#-action_menu.gd)

---

## Combat.tscn

Combat contiene la base di tutta la scena combat.
Dentro ci sono tutti gli elementi utili al combat, questa la struttura:

```
Combat
│
├── Turnmanager
├── Background
├── TurnStatus                  #Label usata per stampare lo status del turno, in alto a sinistra
├── AngelicDinosaur             # Gruppo del nemico con sotto le sue varie parti
│   ├── DS_Torso                # Parti del nemico, DS_torso, DS_head, etc
│   ├── ...
├── Fire                        # Pulsanti per gli elementi, placeholder per ora
├── ...
├── NextTurn                    # Pulsante per passare al turno successivo
├── Party                       # Gruppo di pg giocanti
│   ├── Character1              # Character1, Character2, etc
│   ├── ...
└── ActionMenu                  # Scena ActionMenu


## combat.gd

---

## Action_Menu.tscn

Contiene i 4 bottoni con i relativi segnali, actions, items, talk e pass.
Tramite action_selected.emit() manda l'azione scelta al combat.

In combat.gd dentro la funzione _on_player_turn(character) ce ora l'effettiva funzione player turn.
Questa per ora semplicemente mostra l'action menu, attende l'azione scelta e procede a stampare nello
status label e nella console l'azione scelta, poi fino a che non si preme pass, o, manualmente next turn, il turno
non passa.

ActionMenu
└── PanelContainer     
    └── VBoxContainer    
        ├── Actions
        └── ...
