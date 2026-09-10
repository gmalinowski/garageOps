GarageOps to w założeniu system operacyjny dla warsztatu samochodowego. Nie chodzi o aplikację typu „lista klientów i kalendarz”, tylko o miejsce, w którym warsztat prowadzi cały przebieg obsługi auta od momentu przyjęcia klienta aż do zakończenia naprawy.

Najprościej wyobrazić to sobie tak: przyjeżdża klient z samochodem. Pracownik warsztatu wyszukuje klienta albo zakłada nowego, przypisuje mu samochód i tworzy nowe zlecenie serwisowe. W zleceniu zapisuje się problem zgłoszony przez klienta, np. „stuki z przodu, kontrolka ABS, wymiana oleju”. Samochód trafia do warsztatu, a zlecenie zaczyna żyć własnym życiem.

W trakcie naprawy mechanik albo recepcja dodają do zlecenia kolejne informacje. Może się okazać, że początkowo miały być tylko klocki hamulcowe, ale po rozebraniu zawieszenia znaleziono również uszkodzony sworzeń. Powstają więc konkretne pozycje pracy: diagnostyka ABS, wymiana klocków, wymiana sworznia, wymiana oleju. Każda taka czynność może mieć status, koszt robocizny, przypisanego mechanika i ewentualnie notatki.

Do tego dochodzą części. Warsztat może zapisać, że do konkretnego zlecenia wykorzystano filtr oleju, 5 litrów oleju, komplet klocków i sworzeń. Z tych danych system może później policzyć koszt części, koszt robocizny i całkowity koszt naprawy.

Samochód ma własną historię niezależną od pojedynczego zlecenia. Jeśli Volvo V70 pojawia się w warsztacie piąty raz, pracownik powinien móc wejść w jego kartę i zobaczyć poprzednie wizyty: kiedy wymieniano rozrząd, kiedy robiono hamulce, jaki był wtedy przebieg, jakie były usterki i co zostało wykonane. Dzięki temu GarageOps staje się czymś więcej niż programem do wystawiania zleceń — zaczyna być bazą wiedzy o samochodach obsługiwanych przez warsztat.

Ważną częścią projektu są statusy procesu. Zlecenie może przechodzić przykładowo przez etapy: przyjęte → diagnostyka → oczekiwanie na decyzję klienta → oczekiwanie na części → naprawa → gotowe do odbioru → zakończone. Dzięki temu właściciel warsztatu może otworzyć dashboard i natychmiast zobaczyć, co aktualnie dzieje się na hali.

To daje też możliwość zrobienia czegoś w rodzaju tablicy pracy. Jeden samochód czeka na części, drugi jest diagnozowany, trzeci jest właśnie składany, a czwarty czeka na odbiór. Z punktu widzenia użytkownika GarageOps zaczyna przypominać połączenie małego ERP, CRM i systemu workflow.

Projekt dobrze działa również jako system dla wielu warsztatów. Każdy warsztat jest osobną organizacją i ma własnych klientów, samochody, pracowników i zlecenia. Jeden użytkownik może być właścicielem warsztatu, inny mechanikiem, a jeszcze inny pracownikiem recepcji. Każda rola może mieć inne uprawnienia.

Możesz myśleć o GarageOps jako o kilku warstwach domeny:

warsztat — organizacja, pracownicy, role;
klient — dane osoby lub firmy;
samochód — VIN, marka, model, silnik, rejestracja, przebieg;
zlecenie serwisowe — konkretna wizyta samochodu;
prace — co trzeba zrobić i co zostało wykonane;
części — co zostało zużyte podczas naprawy;
koszty — robocizna, części, suma;
historia — poprzednie wizyty i naprawy;
workflow — aktualny etap naprawy;
użytkownicy — kto wykonywał poszczególne operacje.

W pierwszej wersji nie musisz robić całego „systemu dla warsztatu”. Wystarczy, że rdzeń będzie bardzo dobry: klient → samochód → zlecenie → czynności → koszt → zakończenie zlecenia.

Później można wokół tego rdzenia dokładać kolejne rzeczy: magazyn części, terminarz, przypomnienia o przeglądach, generowanie PDF z kosztorysem, wiadomości do klienta, zdjęcia usterek, historię zmian, raporty finansowe albo publiczny link, pod którym klient może sprawdzić stan naprawy.

Najważniejsze, żebyś w głowie nie traktował GarageOps jako „aplikacji o samochodach”. To jest przede wszystkim system zarządzający procesem pracy warsztatu, a samochód jest głównym obiektem, wokół którego ten proces się odbywa. To właśnie sprawia, że domena jest wystarczająco bogata na dobry projekt Rails.
