public class Main {
    public static void main(String[] args) {
        Main obj = new Main();
        obj.myTestFunction();
    }
    
    public void myTestFunction () {
        MyHashMap myMap = new MyHashMap<String, Integer>();
        myMap.put("Hello", 1);
        System.out.println(myMap.get("Hello"));
        System.out.println(myMap.getSize());
        
        
        MyHashMap myOtherMap = new MyHashMap<Integer, String>().hashTableSize(10);
        myOtherMap.put(1, "Hello");
        myOtherMap.put(2, "Hello");
        myOtherMap.put(3, "Hello");
        myOtherMap.put(4, "Hello");
        myOtherMap.put(5, "Hello");
        myOtherMap.put(6, "Hello");
        myOtherMap.put(7, "Hello");
        myOtherMap.put(8, "Hello");
        myOtherMap.put(9, "Hello");
        myOtherMap.put(10, "Hello");
        System.out.println(myOtherMap.get(1));
        System.out.println(myOtherMap.getSize());

    }
    
    class MyHashMap<K, V> {

    int HASH_TABLE_SIZE = 1000;
    ArrayList<LinkedList<K, V>> hashTable;
    int numberOfItems = 0;
    double LOAD_FACTOR = 0.75;

    public MyHashMap() {
        this.hashTable = new ArrayList<LinkedList<K,V>>(Collections.nCopies(this.HASH_TABLE_SIZE, null));
    }
        
    public MyHashMap hashTableSize(int hashTableSize) {
        this.hashTable = new ArrayList<LinkedList<K,V>>(Collections.nCopies(hashTableSize, null));
        return this;
    }
        
    public int getSize() {
        return hashTable.size();
    }
    
    public void put(K key, V value) {
        int index = this.hashFunction(key);
        if (this.hashTable.get(index) == null) {
            this.hashTable.set(index, new LinkedList());
        }
        this.numberOfItems += this.hashTable.get(index).addNode(key, value);
        if ((double) this.numberOfItems/this.hashTable.size() > LOAD_FACTOR) {
            reHash(hashTable.size() * 2);
        }
    }
    private void reHashPut(K key, V value) {
        int index = hashFunction(key);
        if (this.hashTable.get(index) == null) {
            hashTable.set(index, new LinkedList());
        }
        this.hashTable.get(index).addNode(key, value);
    }   
        
        
    private void reHash(int newSize) {
        ArrayList<LinkedList<K, V>> oldHashTable = this.hashTable;
        this.hashTable =  new ArrayList<LinkedList<K, V>>(Collections.nCopies(newSize, null));
        for (int i = 0; i < oldHashTable.size(); i++) {
            if (oldHashTable.get(i) != null) {
                Node curr = oldHashTable.get(i).getHead();
                while (curr != null) {
                    this.reHashPut((K) curr.getKey(), (V) curr.getValue());
                    curr = curr.getNext();
                }
            }
        }
    }
    
    public V get(K key) {
        int index = hashFunction(key);
        if (this.hashTable.get(index) == null) {
            return null;
        }
        return this.hashTable.get(index).getValue(key);
    }
    
    public void remove(K key) {
        int index = hashFunction(key);
        if (this.hashTable.get(index) == null) {
            return;
        }
        this.hashTable.get(index).removeNode(key);
    }


    private int hashFunction(K key) {
        return key.hashCode() % this.hashTable.size();
    }

    class LinkedList<K,V> {

        Node<K,V> head;
        Node<K,V> tail;
        
        public LinkedList() {
            this.head = null;
            this.tail = null;
        }

        public V getValue(K key) {
            Node<K,V> curr = this.head;
            while (curr != null) {
                if (curr.getKey().equals(key)) {
                    return curr.getValue();
                }
                curr = curr.getNext();
            }
            return null;
        }
        
        public Node getHead() {
            return this.head;
        }

        public int addNode(K key, V value) {
            int elementDiff = 0;
            elementDiff = elementDiff - removeNode(key);
            if (tail == null) {
                this.head = new Node(key, value, null);
                this.tail = head;
            } else {
                Node<K,V> newNode = new Node(key, value, null);
                this.tail.setNext(newNode);
                this.tail = newNode;
            }
            return elementDiff + 1;
        }
        
        // Returns number of removed elements
        public int removeNode(K key) {
            Node<K,V> curr = this.head;
            Node<K,V> prev = null;
            while(curr != null) {
                if (curr.getKey().equals(key)) {
                    performNodeRemoval(curr, prev);
                    return 1;
                }
                prev = curr;
                curr = curr.getNext();
            }
            return 0;
        }

        private void performNodeRemoval(Node curr, Node prev) {
            if (curr.equals(this.head)) {
                this.head = curr.getNext();
            }
            if (curr.equals(this.tail)) {
                this.tail = prev;
            }
            if(prev != null) {
                prev.setNext(curr.getNext());
            }
        }

        
    }
        class Node <K,V> {

            K key;
            V value;
            Node next;

            public Node(K key, V value, Node next) {
                this.key = key;
                this.value = value;
                this.next = next;
            }

            public void setNext(Node next){
                this.next = next;
            }

            public Node getNext(){
                return this.next;
            }

            public K getKey(){
                return this.key;
            }

            public V getValue(){
                return this.value;
            }
        }
}
}
