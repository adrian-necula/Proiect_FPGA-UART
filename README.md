# Proiect_FPGA-UART
Implementare UART TX/RX pe placa Nexys A7, verificata prin simulare si extinsa cu loopback si logger interactiv cu contor binar.


## Etapa 1 — UART Loopback (TX + RX) - Cerinta:
În această etapă implementați și verificați modulele UART de bază. Scopul este să demonstrați că tot ce trimiteți din PuTTY vă vine înapoi corect pe același terminal (loopback hardware):
PuTTY → recepție UART → (fără procesare) → transmisie UART → PuTTY.

## Rezolvare:
Ca sursa de inspiratie am folosit videoclipurile din cursul ECE4305, modulul M8, unde este prezentata functionarea comunicatiei UART. Am gandit sistemul astfel incat fiecare parte sa fie realizata separat si verificata mai intai in simulare, iar dupa aceea modulele sa fie legate impreuna pentru realizarea loopback-ului.

Sistemul a fost impartit astfel:

- un modul pentru generarea semnalului de baud rate;
- un modul uart_tx pentru transmiterea datelor;
- un modul uart_rx pentru receptionarea datelor;
- cate un testbench pentru verificarea fiecarui modul;
- un modul top_uart in care toate componentele vor fi conectate.

La final, datele primite de la calculator vor fi trimise direct inapoi, fara sa fie modificate:

PuTTY -> uart_rx -> uart_tx -> PuTTY

Pentru inceput, am ales comunicatia la 9600 baud, cu 8 biti de date, fara paritate si cu un bit de stop.

## Generatorul de baud rate

Primul modul implementat a fost baud_rate_generator. Acesta primeste clock-ul de 100 MHz si genereaza semnalul tick, folosit pentru temporizarea modulelor UART.

Pentru inceput am ales un caz concret:

- baud rate: 9600 biti/s;
- 16 esantioane pentru fiecare bit UART;
- clock: 100 MHz;
- contorul numara de la 0 la 650.

La fiecare atingere a valorii 650, contorul revine la 0, iar semnalul tick devine 1 pentru un singur ciclu de clock.

Pentru verificare am realizat testbench-ul test_baud_rate_generator. In simulare am observat ca impulsurile tick apar periodic, la aproximativ 6,5 microsecunde.

## Transmitatorul UART

Dupa generatorul de baud rate am implementat modulul uart_tx, care primeste un byte de 8 biti si il transmite serial.

Transmiterea unui caracter este realizata astfel:

- un bit de start, cu valoarea 0;
- 8 biti de date, transmisi de la LSB la MSB;
- un bit de stop, cu valoarea 1;
- fiecare bit este mentinut timp de 16 impulsuri tick.

Modulul este realizat cu ajutorul unei masini de stari, formata din starile:

- TX_IDLE;
- TX_START;
- TX_DATA;
- TX_STOP.

Am adaugat si semnalul bit_pulse, pentru a putea observa mai usor in simulare momentul in care incepe transmiterea unui bit nou.

Pentru verificare am realizat testbench-ul test_uart_tx, in care am transmis caracterul ASCII "A", reprezentat prin valoarea "8'h41". In simulare s-au observat corect bitul de start, cei 8 biti de date si bitul de stop.
