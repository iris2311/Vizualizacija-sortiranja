
int[] array; // korisnički niz brojeva
int[] originalArray; // početni niz brojeva, čuva se kopija
int i = 0, j = 0;
boolean sorted = false;
boolean isRunning = false; // varijabla za kontrolu pokretanja algoritma
boolean isPaused = false;
String algorithm = "";
float speed = 0.5; // brzina sortiranja (od 0.5 do 5)
String input = ""; // korisnički unos
boolean showMenu = true;
int stepCounter = 0; // brojač koraka
int iterationCounter = 0; // brojač iteracija
int pivot = -1; // za Quick Sort
int partitionIndex = 0; // za Quick Sort
int bubbleSortIndex = 0; // za Bubble Sort
boolean bubbleSwapped = false; // za Bubble Sort

void setup() {
  size(1200, 750); 
  textSize(18);
  frameRate(30);
}

void draw() {
  background(180, 240, 200); 
  
  if (showMenu) {
    fill(0);
    text("Dobrodošli u aplikaciju za vizualizaciju algoritama sortiranja!", 400, 50);
    text("1. Unesite niz brojeva razdvojenih zarezima i pritisnite ENTER.", 400, 90);
    text("2. Odaberite algoritam sortiranja klikom na odgovarajući gumb.", 400, 120);
    text("3. Koristite gumbe za upravljanje (pauza, ubrzanje, usporavanje).", 400, 150);
    text("Unesite svoj niz brojeva: " + input, 400, 200);
  }
  else {
    fill(0);
    text("Algoritam: " + algorithm, 100, 50);
    text("Brzina: " + speed + "x", 100, 80);
    text("Početni niz: " + join(nf(originalArray, 0), ", "), 450, 110);
    text("Broj iteracija: " + iterationCounter, 100, 140);
    if (sorted) {
      text("Sortirano!", 100, 170);
    }

    displayArray();

    if (isRunning && !isPaused) {
      stepCounter++;
      if (stepCounter > 30 / speed) {
        stepCounter = 0;
        if (algorithm.equals("Bubble Sort")) {
          bubbleSortStep();
        } else if (algorithm.equals("Selection Sort")) {
          selectionSortStep();
        } else if (algorithm.equals("Insertion Sort")) {
          insertionSortStep();
        } else if (algorithm.equals("Quick Sort")) {
          quickSortStep();
        }
        iterationCounter++;
      }
    }
  }

  drawButtons();
}

void keyPressed() {
  if (showMenu && key == ENTER) {
    String[] numbers = split(input, ',');
    originalArray = int(numbers); // spremi originalni niz
    array = originalArray.clone(); // kopiraj u trenutni niz
    showMenu = false;
  } else if (showMenu) {
    if (key != BACKSPACE) {
      input += key;
    } else if (input.length() > 0) {
      input = input.substring(0, input.length() - 1);
    }
  }
}


void mousePressed() {
  if (mouseY > 600 && mouseY < 650) {
    if (mouseX > 50 && mouseX < 250) {
      algorithm = "Bubble Sort";
      resetSorting();
    } else if (mouseX > 270 && mouseX < 470) {
      algorithm = "Selection Sort";
      resetSorting();
    } else if (mouseX > 490 && mouseX < 690) {
      algorithm = "Insertion Sort";
      resetSorting();
    } else if (mouseX > 710 && mouseX < 910) {
      algorithm = "Quick Sort";
      resetSorting();
    } else if (mouseX > 930 && mouseX < 1130) {
      isPaused = !isPaused;
    }
  } else if (mouseY > 660 && mouseY < 710) {
    if (mouseX > 50 && mouseX < 250) {
      speed = constrain(speed + 0.5, 0.5, 5);
    } else if (mouseX > 270 && mouseX < 470) {
      speed = constrain(speed - 0.5, 0.5, 5);
    } else if (mouseX > 490 && mouseX < 690) {
      resetProgram();
    }
  }
}

void drawButtons() {
  fill(150, 180, 200);
  rect(50, 600, 200, 50);
  rect(270, 600, 200, 50);
  rect(490, 600, 200, 50);
  rect(710, 600, 200, 50);
  rect(930, 600, 200, 50);
  rect(50, 660, 200, 50);
  rect(270, 660, 200, 50);
  rect(490, 660, 200, 50);

  fill(0);
  textAlign(CENTER, CENTER);
  text("Bubble Sort", 150, 625);
  text("Selection Sort", 370, 625);
  text("Insertion Sort", 590, 625);
  text("Quick Sort", 810, 625);
  text(isPaused ? "Nastavi" : "Pauza", 1030, 625);
  text("Ubrzaj", 150, 685);
  text("Uspori", 370, 685);
  text("Ponovno pokreni", 590, 685);
}

void displayArray() {
  int maxPerLine = 15;  // broj brojeva po retku, radi ljepšeg ispisa većih nizova
  int xStart = 50;
  int yStart = 200;
  int lineHeight = 35;

  int maxNumWidth = 80; // širina broja 

  // osiguravamo da širina broja bude dovoljno velika da se brojevi ne preklapaju
  for (int k = 0; k < array.length; k++) {
    // računamo širinu za broj u zavisnosti od broja njegovih znamenki
    int numWidth = (int) (textWidth(array[k] + "") + 10); 

    // osiguravamo da širina broja bude barem maxNumWidth 
    numWidth = max(numWidth, maxNumWidth);

    // ako je broj na poziciji k uspoređivan, označavamo ga crvenom bojom
    if (algorithm.equals("Bubble Sort") && (k == bubbleSortIndex || k == bubbleSortIndex + 1)) {
      fill(255, 0, 0); 
    } else if (algorithm.equals("Selection Sort") && (k == i || k == j)) {
      fill(255, 0, 0); 
    } else if (algorithm.equals("Insertion Sort") && (k == i || k == j)) {
      fill(255, 0, 0); 
    } else if (algorithm.equals("Quick Sort") && (k == pivot || k == partitionIndex)) {
      fill(255, 0, 0); // crvena boja za pivot i trenutni element usporedbe
    } else {
      fill(0); // standardna boja za ostale brojeve
    }

    // ako je broj na poziciji k uspoređivan, prikazujemo ga crvenom
    text(array[k], xStart + (k % maxPerLine) * numWidth, yStart + (k / maxPerLine) * lineHeight);
  }


}


// --- Implementacija algoritama ---

// bubble Sort
void bubbleSortStep() {
  if (!isRunning) return;
  
  if (bubbleSortIndex < array.length - 1 - i) {
    if (array[bubbleSortIndex] > array[bubbleSortIndex + 1]) {
      int temp = array[bubbleSortIndex];
      array[bubbleSortIndex] = array[bubbleSortIndex + 1];
      array[bubbleSortIndex + 1] = temp;
      bubbleSwapped = true;
    }
    bubbleSortIndex++;
  } else {
    bubbleSortIndex = 0;
    i++;
    if (i >= array.length - 1) {
      sorted = true;
      isRunning = false;
    }
  }
}

// selection Sort
void selectionSortStep() {
  if (!isRunning) return;

  if (i < array.length - 1) {
    int minIdx = i;
    for (j = i + 1; j < array.length; j++) {
      if (array[j] < array[minIdx]) {
        minIdx = j;
      }
    }
    if (minIdx != i) {
      int temp = array[i];
      array[i] = array[minIdx];
      array[minIdx] = temp;
    }
    i++;
  } else {
    sorted = true;
    isRunning = false;
  }
}

// insertion Sort
void insertionSortStep() {
  if (!isRunning) return;
  
  if (i < array.length) {
    int current = array[i];
    j = i - 1;
    while (j >= 0 && array[j] > current) {
      array[j + 1] = array[j];
      j--;
    }
    array[j + 1] = current;
    i++;
  } else {
    sorted = true;
    isRunning = false;
  }
}

//  quick Sort
void zamjena(int[] a, int i, int j) {
  int temp = a[i];
  a[i] = a[j];
  a[j] = temp;
}

int izbor_pivota(int[] a, int l, int d) {
  return l; // pivot je prvi element (l)
}

int particioniranje(int[] a, int l, int d) {
  int p = l, j;
  for (j = l + 1; j <= d; j++) {
    if (a[j] < a[l]) {
      zamjena(a, ++p, j); // zamjena elementa
    }
  }
  zamjena(a, l, p); // postavljanje pivota na odgovarajuće mjesto
  pivot = p; // ažuriranje pozicije pivota
  return p;
}

void qsort_(int[] a, int l, int d) {
  if (l < d) {
    zamjena(a, l, izbor_pivota(a, l, d));
    int p = particioniranje(a, l, d);
    qsort_(a, l, p - 1); // rekurzivni poziv za lijevi podniz
    qsort_(a, p + 1, d); // rekurzivni poziv za desni podniz
  }
}

void qsort(int[] a, int n) {
  qsort_(a, 0, n - 1); // pokrećemo QuickSort algoritam
}

// glavna funkcija koja upravlja koracima algoritma
void quickSortStep() {
  if (!isRunning) return;
  
  if (stepCounter == 0) {
    qsort(array, array.length);
    sorted = true;
    isRunning = false;
  }
  stepCounter++;
}

// --- resetiranje funkcija ---
void resetSorting() {
  i = 0;
  j = 0;
  bubbleSortIndex = 0;
  bubbleSwapped = false;
  sorted = false;
  isRunning = true;
  isPaused = false;
  iterationCounter = 0;
  array = originalArray.clone(); // resetiraj na početni niz
}

void resetProgram() {
  showMenu = true;
  input = "";
  algorithm = "";
  sorted = false;
  iterationCounter = 0;
  isRunning = false;
  isPaused = false;
  array = new int[0];
  originalArray = new int[0];
  setup();
}
