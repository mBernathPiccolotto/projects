// "static void main" must be defined in a public class.
public class Main {
    
    public static void main(String[] args) {
        // Create an instance of the class
        Main obj = new Main();
        
        // Call the non-static method using the object
        obj.myFunction();
    }
    
    public void myFunction () {
        /*
        MinHeap myHeap = new MinHeap().heapSize(10);
        myHeap.put(10);
        myHeap.put(9);
        myHeap.put(11);
        myHeap.put(8);
        myHeap.put(6);
        myHeap.put(12);
        */

       Integer[] intArray = {10, 9, 11, 8, 6, 11};
       heapSortInPlace(intArray);
        for (Integer i = 0; i < intArray.length; i++) {
            System.out.println(intArray[i]);
        }
    }
    
    public Integer[] heapSortInPlace(Integer[] inputArray) {
        MinHeap minHeap = new MinHeap();
        for (Integer i = 0; i < inputArray.length; i++) {
            minHeap.put(inputArray[i]);
        }
        for (Integer i = 0; i < inputArray.length; i++) {
            inputArray[i] = minHeap.pop();
        }
        return inputArray;
    }
    
    public class MinHeap {
        
        private Integer[] heap;
        private int heapSize = 12;
        private int FIRST_INDEX = 1;
        private int nextAvailableSpotIndex = FIRST_INDEX;

        
        public MinHeap() {
            this.heap = new Integer[this.heapSize];
        }
        
        public void printHeap() {
            for (Integer i = 0; i < heapSize; i++) {
                System.out.println(this.heap[i]);
            }
                            System.out.println("------------");

        }
        
        public MinHeap heapSize(int heapSize) {
            this.heap = new Integer[heapSize];
            this.heapSize = heapSize;
            return this;
        }
        
        public int getSize() {
            return heapSize;
        }
        
        public Integer pop() {
            Integer toReturn = this.heap[FIRST_INDEX];
            if (toReturn != null) {
                this.heap[FIRST_INDEX] = this.heap[nextAvailableSpotIndex - 1];
                this.heap[nextAvailableSpotIndex - 1] = null;
                heapifyDown();
                nextAvailableSpotIndex--;
            }
            return toReturn;
        }
        
        public Integer peak() {
            return this.heap[1];
        }
        
        public void put(Integer newAddition) {
            // Todo what if we are out of space
            this.heap[this.nextAvailableSpotIndex] = newAddition;
            this.heapifyUp();
            this.nextAvailableSpotIndex++;
        }
        
        private void heapifyDown() {
            int curr = FIRST_INDEX;
            while (!this.heapProperyCorrect(curr)) {
                if (this.heap[getRightChildIndex(curr)] == null || this.heap[getRightChildIndex(curr)] > this.heap[getLeftChildIndex(curr)]) {
                    Integer temp = this.heap[curr];
                    this.heap[curr] = this.heap[getLeftChildIndex(curr)];
                    this.heap[getLeftChildIndex(curr)] = temp;
                    curr = getLeftChildIndex(curr);
                } else {
                    Integer temp = this.heap[curr];
                    this.heap[curr] = this.heap[getRightChildIndex(curr)];
                    this.heap[getRightChildIndex(curr)] = temp;
                    curr = getRightChildIndex(curr);
                }
            }
        }
        
        private void heapifyUp() {
            int curr = this.nextAvailableSpotIndex;
            while (!this.heapProperyCorrect(curr)) {
                Integer temp = this.heap[curr];
                this.heap[curr] = this.heap[getParentIndex(curr)];
                this.heap[getParentIndex(curr)] = temp;
                curr = getParentIndex(curr);
            }
        }
        
        private boolean heapProperyCorrect(int index) {
            if (this.heap[index] == null) {
                return true;
            }
            if (getLeftChildIndex(index) != 0 && this.heap[getLeftChildIndex(index)] != null && this.heap[getLeftChildIndex(index)] < this.heap[index]) {
                return false;
            }
            if (getRightChildIndex(index) != 0 && this.heap[getRightChildIndex(index)] != null && this.heap[getRightChildIndex(index)] < this.heap[index]) {
                return false;
            }
            if (index != 1 && this.heap[getParentIndex(index)] > this.heap[index]) {
                return false;
            }
            return true;
        }
        
        private int getLeftChildIndex(int index) {
            if (2 * index < heapSize) {
                return 2 * index;
            }
            return 0;
        }
        
        private int getRightChildIndex(int index) {
            if (2 * index + 1 < heapSize) {
                return 2 * index + 1;
            }
            return 0;

        }
        
        private int getParentIndex(int index) {
            return index/2;
        }
        
        
        
    }
}
