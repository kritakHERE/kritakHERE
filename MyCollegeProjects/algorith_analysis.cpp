// DataStructureAssignment.cpp
// Full implementation of DCLL with Binary, Exponential Search and Quick, Merge Sort (No Vectors)

#include <iostream>
#include <chrono>
#include <cstdlib>  // for rand()
#include <ctime>    // for time()
using namespace std;

// -------------------- NODE STRUCT --------------------
struct Node {
    int data;
    Node* next;
    Node* prev;
};

// -------------------- DCLL FUNCTIONS --------------------
Node* head = nullptr;
int listSize = 0;

void insertEnd(int value) {
    Node* newNode = new Node;
    newNode->data = value;
    if (!head) {
        newNode->next = newNode->prev = newNode;
        head = newNode;
    } else {
        Node* last = head->prev;
        last->next = newNode;
        newNode->prev = last;
        newNode->next = head;
        head->prev = newNode;
    }
    listSize++;
}

void displayList() {
    if (!head) return;
    Node* temp = head;
    do {
        cout << temp->data << " ";
        temp = temp->next;
    } while (temp != head);
    cout << endl;
}

void copyToArray(int arr[]) {
    if (!head) return;
    Node* temp = head;
    int i = 0;
    do {
        arr[i++] = temp->data;
        temp = temp->next;
    } while (temp != head);
}

// -------------------- SORTING FUNCTIONS --------------------
void quickSort(int arr[], int low, int high);
int partition(int arr[], int low, int high);

void mergeSort(int arr[], int l, int r);
void merge(int arr[], int l, int m, int r);

int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (arr[j] < pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

void merge(int arr[], int l, int m, int r) {
    int n1 = m - l + 1;
    int n2 = r - m;
    int* L = new int[n1];
    int* R = new int[n2];

    for (int i = 0; i < n1; i++) L[i] = arr[l + i];
    for (int j = 0; j < n2; j++) R[j] = arr[m + 1 + j];

    int i = 0, j = 0, k = l;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) arr[k++] = L[i++];
        else arr[k++] = R[j++];
    }
    while (i < n1) arr[k++] = L[i++];
    while (j < n2) arr[k++] = R[j++];

    delete[] L;
    delete[] R;
}

void mergeSort(int arr[], int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;
        mergeSort(arr, l, m);
        mergeSort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}

// -------------------- SEARCHING FUNCTIONS --------------------
int binarySearch(int arr[], int size, int target) {
    int low = 0, high = size - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

int exponentialSearch(int arr[], int size, int target) {
    if (arr[0] == target) return 0;
    int i = 1;
    while (i < size && arr[i] <= target) i *= 2;
    int low = i / 2;
    int high = min(i, size - 1);
    while (low <= high) {
        int mid = (low + high) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

// -------------------- RUNTIME ANALYSIS --------------------
void measureAndRunSort(int arr[], int size, string name, void (*sortFunc)(int[], int, int)) {
    int* copy = new int[size];
    for (int i = 0; i < size; i++) copy[i] = arr[i];
    auto start = chrono::high_resolution_clock::now();
    sortFunc(copy, 0, size - 1);
    auto end = chrono::high_resolution_clock::now();
    cout << name << " took: "
         << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
         << " nanoseconds\n";
    delete[] copy;
}

void measureAndRunSearch(int arr[], int size, string name, int (*searchFunc)(int[], int, int), int target) {
    auto start = chrono::high_resolution_clock::now();
    int result = searchFunc(arr, size, target);
    auto end = chrono::high_resolution_clock::now();
    cout << name << " found " << target << " at index: ";
    if (result == -1)
        cout << "not found";
    else
        cout << result;
    cout << ", time: " << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
         << " nanoseconds\n";
}

// -------------------- MAIN --------------------
int main() {
    srand(time(0));
    int N;
    cout << "Enter number of elements (N): ";
    cin >> N;

    // Fill DCLL with random values
    for (int i = 0; i < N; i++) {
        int val = rand() % N;
        insertEnd(val);
    }

    cout << "\nOriginal List:\n";
    displayList();

    // --- Copy to two arrays ---
    int* arrQuick = new int[N];
    int* arrMerge = new int[N];
    copyToArray(arrQuick);
    copyToArray(arrMerge);

    // --- Sort each array with a different algorithm ---
    cout << "\n-- Sorting Analysis --\n";
    auto start = chrono::high_resolution_clock::now();
    quickSort(arrQuick, 0, N - 1);
    auto end = chrono::high_resolution_clock::now();
    cout << "Quick Sort took: "
         << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
         << " nanoseconds\n";

    start = chrono::high_resolution_clock::now();
    mergeSort(arrMerge, 0, N - 1);
    end = chrono::high_resolution_clock::now();
    cout << "Merge Sort took: "
         << chrono::duration_cast<chrono::nanoseconds>(end - start).count()
         << " nanoseconds\n";

    // --- Display sorted arrays ---
    cout << "\nQuick Sorted Array:\n";
    for (int i = 0; i < N; i++) cout << arrQuick[i] << " ";
    cout << endl;

    cout << "\nMerge Sorted Array:\n";
    for (int i = 0; i < N; i++) cout << arrMerge[i] << " ";
    cout << endl;

    // --- Prompt for search value ---
    int target;
    cout << "\nEnter value to search: ";
    cin >> target;

    // --- Search each sorted array with a different algorithm ---
    cout << "\n-- Searching Analysis --\n";
    measureAndRunSearch(arrQuick, N, "Binary Search (Quick Sorted)", binarySearch, target);
    measureAndRunSearch(arrMerge, N, "Exponential Search (Merge Sorted)", exponentialSearch, target);

    delete[] arrQuick;
    delete[] arrMerge;
    return 0;
}
