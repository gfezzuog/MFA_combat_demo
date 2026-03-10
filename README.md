# Documentazione

- [Combat.tscn](#combattscn)
- [Combat.gd](#combatgd)
- [Action_Menu.tscn](#action_menutscn)
- [Turn_Manager.gd](#turn_managergd)

---

## Combat.tscn

Combat contiene tutti gli elementi utili al combat, questa è la struttura:

```
Combat
│
├── TurnManager                 # Nodo contenente lo script che gestisce i turni
├── Background
├── TurnStatus                  # Label usata per stampare lo status del turno, in alto a sinistra
├── AngelicDinosaur             # Gruppo del nemico con sotto le sue varie parti
│   ├── DS_Torso                # Parti del nemico, DS_torso, DS_head, etc
│   ├── ...
├── Fire                        # Pulsanti per gli elementi, placeholder per ora
├── ...
├── NextTurn                    # Pulsante per passare al turno successivo
├── Party                       # Gruppo di pg giocanti
│   ├── Character1              # Character1, Character2, etc
│   │   ├── PlayerStatus1       # Label con nome e hp del player
│   ├── ...
└── ActionMenu                  # Scena ActionMenu
```

---

## Combat.gd
Contiene vari @onready con pulsanti, label e l'action menu.
Lo script si suddivide in queste funzioni:

**_ready**:
Inizializzazione party e enemies con ".get_children".
Connect al turn_manager.
Avvio turn_manager tramite ".start_combat".

**_process**:
Gestione dei label dei player che aggiorna hp costantemente, si può aggiungere altro.

**_on_player_turn**:
Riceve il segnale da Turn Manager.
Aggiornamento TurnStatus e avvio player_turn, attende che finisca.

**_on_enemy_turn**:
Riceve il segnale da Turn Manager.
Per ora semplicemente aggiorna TurnStatus e attende la pressione del pulsante NextTurn.

**player_turn**:
Mostra action_menu.
Entra in ciclo while true.
Attende la selezione di un'azione, questo avviene tramite segnali dentro Action_Menu.gd e la scena ActionMenu.
Presa la scelta stampa nel TurnStatus e basta, quando si sceglie pass, termina il turno.

---

## Action_Menu.tscn

Contiene i 4 bottoni con i relativi segnali, actions, items, talk e pass.
Tramite action_selected.emit() manda l'azione scelta a Combat dentro la funzione player_turn.

Questa è la struttura:

```
ActionMenu                      
└── PanelContainer              # Panel utile per lo style
	└── VBoxContainer           # Container per i pulsanti
		├── Actions             # Pulsanti
		└── ...
```
---

## Turn_Manager.gd

Contiene 3 array, uno con i player (party) e uno con i nemici (enemies) e l'ultimo vuoto (turn_queue) che sarà la coda del turno.
2 segnali player_turn_started e enemy_turn_started.

Le funzioni sono:

**start_combat**:
Inizializza gli array party e enemies.
Chiama build_turn_queue.
E infine next_turn che la prima volta semplicemente farà partire all'effettivo il loop recursivo dei turni.

**build_turn_queue**:
Svuota la queue, questo perché verrà richiamata ogni inizio turno e ricalcola ogni volta le speed nel caso cambiassero.
Prende tutte le unità e calcola le speed mettendole in ordine nella queue (turn_queue).

**next_turn**:
Controlla che il combat è ancora in corso (check_battle_end).
Se la queue è empty richiama build_turn_queue, questo si verificherà ad ogni inizio nuovo "ciclo" quando l'ultimo della fila ha agito e si riparte dal primo.
Se invece la queue è piena quindi siamo in pieno ciclo, semplicemente porta avanti la fila di uno fino a che non trova un pg (sia player che nemico) che sia vivo.
Poi controlla che il pg selezionato sia nel party del player oppure un nemico, e emette il segnale corrispondente che verrà ricevuto da combat.gd

**end_turn**:
Richiama next_turn.

**check_battle_end**:
Controllo se il combat è finito, se tutto il party è morto è game over, se invece tutti i nemici sono morti è victory.

---
