# Documentazione Sistema di Combattimento

Sistema di combattimento a turni per Godot 4.x che gestisce party, nemici, turni basati su velocità e menu azioni.

## Indice

- [Combat.tscn](#combattscn) - Scena principale del combattimento
- [Action_Menu.tscn](#action_menutscn) - Menu azioni giocatore
- [Turn_Manager.gd](#turn_managergd) - Gestore turni

---

## Combat.tscn

Scena principale che contiene tutti gli elementi del sistema di combattimento: personaggi, nemici, UI e gestione turni.

**Struttura:**

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

Controller principale del combattimento che coordina Turn Manager, personaggi, nemici e interfaccia utente.

### Funzioni principali:

**`_ready()`**
- Raccoglie tutti i nodi del party tramite `$Party.get_children()`
- Raccoglie tutti i nodi nemici tramite `$AngelicDinosaur.get_children()`
- Connette i segnali `player_turn_started` e `enemy_turn_started` del Turn Manager
- Avvia il combattimento chiamando `turn_manager.start_combat(party_nodes, enemy_nodes)`

**`_process(delta)`**
- Aggiorna costantemente i label dei personaggi con nome e HP corrente/massimo
- Chiamata ogni frame per mantenere UI sincronizzata

**`_on_player_turn(character)`**
- Callback chiamato dal segnale `player_turn_started` del Turn Manager
- Riceve come parametro il personaggio che deve agire
- Aggiorna `turn_status` con il nome del personaggio corrente
- Attende il completamento di `player_turn(character)` usando `await`
- Al termine nasconde il menu e chiama `turn_manager.end_turn()`

**`_on_enemy_turn(character)`**
- Callback chiamato dal segnale `enemy_turn_started` del Turn Manager
- Aggiorna `turn_status` con il nome del nemico corrente
- Attende pressione di `next_turn_button` (placeholder per AI nemico)
- Nasconde il menu e avanza al turno successivo

**`player_turn(character)`**:
- Mostra action_menu.
- Entra in ciclo while true.
- Attende la selezione di un'azione, tramite segnali da Action_Menu.gd e la scena ActionMenu.
- Presa la scelta stampa nel TurnStatus, quando si sceglie pass, termina il turno.

---

## Action_Menu.tscn

Contiene i 4 bottoni con i relativi segnali, actions, items, talk e pass.
Tramite action_selected.emit() manda l'azione scelta a Combat dentro la funzione player_turn.

- `party`: Array contenente tutti i personaggi del giocatore
- `enemies`: Array contenente tutti i nemici
- `turn_queue`: Array che mantiene l'ordine dei turni, ordinato per velocità decrescente

**Struttura:**

```
ActionMenu
└── PanelContainer              # Panel per lo styling del menu
	└── VBoxContainer           # Container verticale per i pulsanti
		├── Actions             # Bottone azioni offensive/difensive
		├── Items               # Bottone utilizzo oggetti
		├── Talk                # Bottone dialogo/negoziazione
		└── Pass                # Bottone per saltare il turno
```

## Action_Menu.gd

Script semplice che gestisce la visibilità del menu e emette segnali quando i bottoni vengono premuti.

**Segnale:**
- `action_selected(action)`: emesso quando il giocatore seleziona un'azione, passa il nome dell'azione come stringa

**Funzioni:**
- `_ready()`: nasconde il menu all'avvio
- `show_menu()`: rende visibile il menu
- `hide_menu()`: nasconde il menu
- `_on_actions_pressed()`: emette `action_selected("actions")`
- `_on_items_pressed()`: emette `action_selected("items")`
- `_on_talk_pressed()`: emette `action_selected("talk")`
- `_on_pass_pressed()`: emette `action_selected("pass")`

---

## Turn_Manager.gd

**Variabili:**
- `party`: array per contenre i pg del player
- `enemies`: array per contenre i nemici
- `turn_queue`: arrey per la coda
- `current_character`: pg o nemico che prende il turno

**Funzioni:**
**`start_combat(party_nodes, enemy_nodes)`**
- Inizializza gli array `party` e `enemies` con i nodi passati come parametri
- Chiama `build_turn_queue()` per creare l'ordine iniziale dei turni
- Avvia il loop dei turni chiamando `next_turn()`

**`build_turn_queue()`**
- Svuota completamente `turn_queue` per ricostruirla da zero
- Unisce party ed enemies in un unico array temporaneo
- Filtra solo le unità vive (`is_alive() == true`) e con velocità > 0
- Ordina l'array in ordine decrescente di velocità usando `sort_custom()`
- Viene richiamata a inizio combattimento e ogni volta che la queue si svuota

**`next_turn()`**
- Controlla se il combattimento è terminato con `check_battle_end()`, se sì termina
- Se `turn_queue` è vuota, ricostruisce la queue chiamando `build_turn_queue()` (nuovo ciclo)
- Estrae il primo personaggio dalla queue con `pop_front()`
- Se il personaggio estratto è morto, continua a estrarre finché non trova uno vivo
- Identifica se è un personaggio del party o un nemico
- Emette il segnale appropriato (`player_turn_started` o `enemy_turn_started`)
- Usa `await` sul segnale per attendere che il turno venga completato

**`end_turn()`**
- Chiama `next_turn()` per passare al prossimo personaggio

**`check_battle_end()`**
- Controlla le condizioni di fine combattimento
- Filtra party ed enemies per contare unità vive usando `is_alive()`
- Se il party è completamente morto: stampa "GAME OVER" e ritorna `true`
- Se tutti i nemici sono morti: stampa "VICTORY" e ritorna `true`
- Altrimenti ritorna `false` e il combattimento continua

---
