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

Pentru simplificarea simularii, semnalul tick a fost mentinut permanent pe 1. Astfel, transmitatorul numara la fiecare ciclu de clock, iar fiecare bit UART este mentinut timp de 16 cicluri.

Aceasta modificare este folosita doar in testbench. In sistemul real, semnalul tick va fi primit de la modulul baud_rate_generator.

## Receptorul UART

Urmatorul modul implementat a fost uart_rx, care primeste datele serial si formeaza din nou byte-ul de 8 biti.

Modulul este realizat cu o masina de stari:

- RX_IDLE - asteapta bitul de start;
- RX_START - verifica bitul de start;
- RX_DATA - citeste cei 8 biti de date;
- RX_STOP - verifica bitul de stop.

Am folosit si semnalul sample_pulse, care indica in simulare momentul in care este citit un bit.

Pentru testare am simulat receptionarea caracterului ASCII "A", adica "8'h41". La finalul simularii, rx_data a avut valoarea "8'h41", iar rx_done a indicat terminarea receptiei.

## Integrarea UART Loopback

Dupa verificarea separata a modulelor uart_rx si uart_tx, acestea au fost conectate in modulul top_uart.

Datele receptionate sunt trimise direct catre transmitator:

- rx_data este conectat la tx_data;
- rx_done este folosit pentru pornirea transmisiei;
- acelasi caracter primit este trimis inapoi fara modificare.

Pentru verificare am realizat testbench-ul test_top_uart, in care am trimis caracterul ASCII "A".

In simulare s-a observat ca valoarea receptionata este "8'h41", iar acelasi cadru UART este transmis inapoi pe iesirea "uart_tx".

## Testarea pe placa

Dupa verificarea in simulare, am adaugat fisierul de constrangeri pentru clock, reset si interfata USB-UART.

Configurarea folosita in PuTTY a fost:

- baud rate: 9600;
- 8 biti de date;
- un bit de stop;
- fara paritate;
- fara control al fluxului;
- local echo dezactivat.

Am programat placa si am trimis mai multe caractere din PuTTY. Caracterele au fost receptionate si trimise inapoi corect.

Pentru verificare, am tinut resetul activ si am observat ca textul nu se mai afisa in PuTTY. Dupa eliberarea resetului, caracterele au inceput din nou sa fie receptionate si retransmise.

Acest test confirma ca textul afisat in terminal este cel trimis inapoi de placa, iar loopback-ul hardware functioneaza corect.
