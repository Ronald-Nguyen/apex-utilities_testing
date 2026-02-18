public class Stack {
    private final List<Object> items = new List<Object>();

    public void push(Object item) {
        if (item == null) {
            throw new IllegalArgumentException('Cannot push null item to stack');
        }
        items.add(item);
    }

    public Object pop() {
        if (isEmpty()) {
            throw new UnderflowException();
        }
        return items.remove(items.size() - 1);
    }

    public Integer size() {
        return items.size();
    }

    public Boolean isEmpty() {
        return items.isEmpty();
    }

    public override String toString() {
        if (isEmpty()) {
            return '';
        }
        return String.join(items, '\n');
    }

    public class UnderflowException extends Exception {
    }
}