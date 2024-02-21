//1
#include <stdio.h>
#define MAX_TERMS 101
typedef struct {
    int col;
    int row;
    int value;
} Term;
Term a[MAX_TERMS];
Term b[MAX_TERMS];
void fastTranspose(Term a[], Term b[]) {
    int rowTerms[a[0].col], startingPos[a[0].col];
    int i, j, numCols = a[0].col, numTerms = a[0].value;
    b[0].row = numCols;
    b[0].col = a[0].row;
    b[0].value = numTerms;
    if (numTerms > 0) {
        for (i = 0; i < numCols; i++)
            rowTerms[i] = 0;
        for (i = 1; i <= numTerms; i++)
            rowTerms[a[i].col]++;
        startingPos[0] = 1;
        for (i = 1; i < numCols; i++)
            startingPos[i] = startingPos[i - 1] + rowTerms[i - 1];
        for (i = 1; i <= numTerms; i++) {
            j = startingPos[a[i].col]++;
            b[j].row = a[i].col;
            b[j].col = a[i].row;
            b[j].value = a[i].value;
        }
    }
}
void simpleTranspose(Term a[], Term b[]) {
    int numTerms = a[0].value;
    b[0].row = a[0].col;
    b[0].col = a[0].row;
    b[0].value = numTerms;
    if (numTerms > 0) {
        int currentB = 1;
        for (int c = 0; c < a[0].col; ++c) {
            for (int i = 1; i <= numTerms; ++i) {
                if (a[i].col == c) {
                    b[currentB].row = a[i].col;
                    b[currentB].col = a[i].row;
                    b[currentB].value = a[i].value;
                    ++currentB;
                }
            }
        }
    }
}
int main() {
    int i;
    printf("Enter the number of rows and columns\n");
    scanf("%d%d", &a[0].row, &a[0].col);
    printf("Enter the number of values\n");
    scanf("%d", &a[0].value);
    for (i = 1; i <= a[0].value; i++) {
        printf("Enter the %dth row, column and element values\n", i);
        scanf("%d%d%d", &a[i].row, &a[i].col, &a[i].value);
    }
    printf("\nOriginal Matrix\n");
    for (i = 1; i <= a[0].value; i++) {
        printf("%d\t%d\t%d\n", a[i].row, a[i].col, a[i].value);
    }
    Term simpleTransposed[MAX_TERMS];
    simpleTranspose(a, simpleTransposed);
    printf("\nSimple Transpose Matrix\n");
    for (i = 1; i <= simpleTransposed[0].value; i++) {
        printf("%d\t%d\t%d\n", simpleTransposed[i].row, simpleTransposed[i].col, simpleTransposed[i].value);
    }
    Term fastTransposed[MAX_TERMS];
    fastTranspose(a, fastTransposed);
    printf("\nFast Transpose Matrix\n");
    for (i = 1; i <= fastTransposed[0].value; i++) {
        printf("%d\t%d\t%d\n", fastTransposed[i].row, fastTransposed[i].col, fastTransposed[i].value);
    }
    return 0;
}



//2
#include <stdio.h>
#include <string.h>
int pmatch(char *string, char *pat, int *failure) {
    int i = 0, j = 0;
    int lens = strlen(string);
    int lenp = strlen(pat);
    while (i < lens && j < lenp) {
        if (string[i] == pat[j]) {
            i++;
            j++;
        } else if (j == 0) {
            i++;
        } else {
            j = failure[j - 1] + 1;
        }
    }
    return ((j == lenp) ? (i - lenp) : -1);
}
void fail(char *pat, int *failure) {
    int i, j, n = strlen(pat);
    failure[0] = -1;
    for (j = 1; j < n; j++) {
        i = failure[j - 1];
        while ((pat[j] != pat[i + 1]) && (i >= 0))
            i = failure[i];
        if (pat[j] == pat[i + 1])
            failure[j] = i + 1;
        else
            failure[j] = -1;
    }
}
int nfind(char *string, char *pat) {
    int i, j, start = 0;
    int lasts = strlen(string) - 1;
    int lastp = strlen(pat) - 1;
    int endmatch = lastp;
    for (i = 0; endmatch <= lasts; endmatch++, start++) {
        if (string[endmatch] == pat[lastp]) {
            for (j = 0, i = start; j < lastp && string[i] == pat[j]; i++, j++);
            if (j == lastp)
                return start;
        }
    }
    return -1;
}
int main() {
    char string[1000], pat[1000];
    printf("Enter a string: ");
    scanf("%s", string);
    printf("Enter a pattern to check if it's present in the entered string: ");
    scanf("%s", pat);
    int failure[strlen(pat)];
    fail(pat, failure);
    int kmpIndex = pmatch(string, pat, failure);
    int nfindIndex = nfind(string, pat);
    printf("KMP Pattern Match: ");
    if (kmpIndex != -1)
        printf("Pattern found at index: %d\n", kmpIndex);
    else
        printf("Pattern not found\n");
    printf("n_find Match: ");
    if (nfindIndex != -1)
        printf("Pattern found at index: %d\n", nfindIndex);
    else
        printf("Pattern not found\n");
    return 0;
}

//3

#include <stdio.h>
#include <stdlib.h>
#define MAX 20
typedef enum { lparen, rparen, plus, minus, times, divide, mod, eos, operand } precedence;
precedence stack[30];
int top = -1;
char EXPR[MAX];
int isp[] = { 0, 19, 12, 12, 13, 13, 13, 0 };
int icp[] = { 20, 19, 12, 12, 13, 13, 13, 0 };
void push(precedence token);
precedence pop();
precedence get_token(char *symbol, int *n);
void print_token(precedence token);
void postfix();
int main() {
    printf("\nEnter the infix expression\n");
    if (scanf("%s", EXPR) != 1) {
        printf("Error reading input.\n");
        return 1;
    }
    postfix();
    return 0;
}
void push(precedence token) {
    if (top >= 29) {
        printf("Stack Overflow\n");
        exit(EXIT_FAILURE);
    }
    stack[++top] = token;
}
precedence pop() {
    if (top == -1) {
        printf("Stack Underflow\n");
        exit(EXIT_FAILURE);
    }
    return stack[top--];
}
precedence get_token(char *symbol, int *n) {
    *symbol = EXPR[(*n)++];
    switch (*symbol) {
    case '(': return lparen;
    case ')': return rparen;
    case '+': return plus;
    case '-': return minus;
    case '*': return times;
    case '/': return divide;
    case '%': return mod;
    case '\0': return eos;
    default: return operand;
    }
}
void print_token(precedence token) {
    switch (token) {
    case plus: printf("+"); break;
    case minus: printf("-"); break;
    case times: printf("*"); break;
    case divide: printf("/"); break;
    case mod: printf("%%"); break;
    }
}
void postfix() {
    char symbol;
    precedence token;
    int n = 0;
    top = 0;
    stack[0] = eos;
    for (token = get_token(&symbol, &n); token != eos; token = get_token(&symbol, &n)) {
        if (token == operand)
            printf("%c", symbol);
        else if (token == rparen) {
            while (stack[top] != lparen)
                print_token(pop());
            pop();
        }
        else {
            while (isp[stack[top]] >= icp[token])
                print_token(pop());
            push(token);
        }
    }
    while ((token = pop()) != eos)
        print_token(token);
    printf("\n");
}


//4

#include<stdio.h>
#define MAX 40
typedef enum { lparen, rparen, plus, minus, times, divide, mod, eos, operand } precedence;
char EXPR[MAX];
int stack[20];
int top = -1;
precedence get_token(char *symbol, int *n) {
    *symbol = EXPR[(*n)++];
    switch (*symbol) {
    case '(': return lparen;
    case ')': return rparen;
    case '+': return plus;
    case '-': return minus;
    case '*': return times;
    case '/': return divide;
    case '%': return mod;
    case '\0': return eos;
    default: return operand;
    }
}
void push(int num) {
    stack[++top] = num;
}
int pop() {
    return stack[top--];
}
int eval() {
    precedence token;
    char symbol;
    int op1, op2, n = 0;
    token = get_token(&symbol, &n);
    while (token != eos) {
        if (token == operand)
            push(symbol - '0');
        else {
            op2 = pop();
            op1 = pop();
            switch (token) {
            case plus:
                push(op1 + op2);
                break;
            case minus:
                push(op1 - op2);
                break;
            case times:
                push(op1 * op2);
                break;
            case divide:
                if (op2 == 0) {
                    printf("Error: Division by zero\n");
                    return -1;
                }
                push(op1 / op2);
                break;
            case mod:
                if (op2 == 0) {
                    printf("Error: Modulo by zero\n");
                    return -1;
                }
                push(op1 % op2);
                break;
            }
        }
        token = get_token(&symbol, &n);
    }
    return pop();
}
int main() {
    int res;
    printf("\nEnter the postfix expression\n");
    scanf("%s", EXPR);
    res = eval();
    if (res != -1)
        printf("\nAfter evaluation:\t%d\n", res);
    return 0;
}

//5

#include<stdio.h>
#include<stdlib.h>
#define MALLOC(x,size,type) (x=(type*)malloc(size*sizeof(type)))
typedef struct {
    int n;
} element;
int front = 0, rear = 0, capacity;
element *queue;
void copy(element *start, element *end, element *newQueue);
void queueFull();
void addq(element item);
element deleteq();
void displayq();
void copy(element *start, element *end, element *newQueue) {
    element *j, *i;
    i = newQueue;
    j = start;
    for (; j < end; j++, i++) {
        *i = *j;
    }
}
void queueFull() {
    element *newQueue;
    MALLOC(newQueue, capacity * 2, element);
    int start = (front + 1) % capacity;
    if (start < 2)
        copy(queue + start, queue + start + capacity - 1, newQueue);
    else {
        copy(queue + start, queue + capacity, newQueue);
        copy(queue, queue + rear + 1, newQueue + capacity - start);
    }
    front = 2 * capacity - 1;
    rear = capacity - 1;
    capacity *= 2;
    free(queue);
    queue = newQueue;
}
void addq(element item) {
    rear = (rear + 1) % capacity;
    if (front == rear)
        queueFull();
    queue[rear] = item;
}
element deleteq() {
    element item;
    if (front == rear) {
        item.n = -1;
        return item;
    }
    front = (front + 1) % capacity;
    return queue[front];
}
void displayq() {
    int i;
    if (front == rear) {
        printf("Queue Empty\n");
        return;
    }
    for (i = (front + 1) % capacity; i != rear; i = (i + 1) % capacity)
        printf("%d\t", queue[i].n);
    printf("%d", queue[i].n);
    printf("\n");
}
int main() {
    int choice;
    element item;
    printf("Enter initial size\n");
    scanf("%d", &capacity);
    MALLOC(queue, capacity, element);
    while (1) {
        printf("1. Add\n2. Delete\n3. Display\n");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                printf("Enter item to add\n");
                scanf("%d", &item.n);
                addq(item);
                break;
            case 2:
                item = deleteq();
                if (item.n == -1)
                    printf("Queue Empty\n");
                else
                    printf("Item deleted: %d\n", item.n);
                break;
            case 3:
                displayq();
                break;
        }
    }
    return 0;
}

//6

#include<stdio.h>
#include<stdlib.h>
typedef struct {
    int key;
} element;
struct stack {
    element data;
    struct stack *link;
};
typedef struct stack *stckptr;
stckptr top = NULL; 
void push(element item) {
    stckptr temp;
    temp = (stckptr)malloc(sizeof(struct stack));
    temp->data = item;
    temp->link = top;
    top = temp;
}
element pop() {
    stckptr temp;
    element item;
    if (top == NULL) {
        item.key = -1; 
        return item;
    }
    else {
        temp = top;
        top = top->link;
        item = temp->data;
        free(temp);
        return item;
    }
}
void display() {
    stckptr temp = top;
    while (temp != NULL) {
        printf("%d\t", temp->data.key);
        temp = temp->link;
    }
}
int main() {
    element item;
    int choice;
    while (1) {
        printf("\nEnter\n1. Push\n2. Pop\n3. Display\n4. Exit\n");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                printf("\nEnter element to push: ");
                scanf("%d", &item.key);
                push(item);
                break;
            case 2:
                item = pop();
                if (item.key == -1)
                    printf("\nStack Underflow!\n");
                else
                    printf("\nPopped element: %d\n", item.key);
                break;
            case 3:
                printf("\nStack: ");
                display();
                break;
            case 4:
                exit(0);
            default:
                printf("\nInvalid choice!\n");
        }
    }
    return 0;
}


//7


#include <stdio.h>
#include <stdlib.h>
typedef struct {
    int key;
} element;
struct queue {
    element data;
    struct queue* link;
};
typedef struct queue* queueptr;
queueptr front = NULL;
queueptr rear = NULL;
void insert(element item) {
    queueptr temp;
    temp = (queueptr)malloc(sizeof(struct queue));
    temp->data = item;
    temp->link = NULL;
    if (rear)
        rear->link = temp;
    else
        front = temp;
    rear = temp;
}
element delete() {
    queueptr temp;
    element item;
    if (front) {
        temp = front;
        item = front->data;
        front = front->link;
        if (front == NULL)
            rear = NULL;
        free(temp);
    } else {
        item.key = -1;
    }
    return item;
}
void display() {
    queueptr temp = front;
    if (temp == NULL) {
        printf("Queue empty\n");
        return;
    }
    while (temp) {
        printf("%d\t", temp->data.key);
        temp = temp->link;
    }
    printf("\n");
}
int main(void) {
    int choice;
    element item;
    while (1) {
        printf("Enter\n 1. Insert\n 2. Delete\n 3. Display\n 4. Exit\n");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                printf("Enter data to be inserted: ");
                scanf("%d", &item.key);
                insert(item);
                break;
            case 2:
                item = delete();
                if (item.key == -1)
                    printf("Queue empty\n");
                else
                    printf("Element deleted: %d\n", item.key);
                break;
            case 3:
                display();
                break;
            case 4:
                exit(0);
            default:
                printf("Invalid choice\n");
        }
    }
    return 0;
}

//8

#include<stdio.h>
#include<stdlib.h>
 typedef struct link {
    int coeff;
    int pow;
    struct link * next;
} my_poly;
void my_create_poly(my_poly **);
void my_show_poly(my_poly *);
void my_add_poly(my_poly **, my_poly *, my_poly *);
int main(void) {
    int ch;
    do {
        my_poly * poly1, * poly2, * poly3;
        printf("\nCreate 1st expression\n");
        my_create_poly(&poly1);
        printf("\nStored the 1st expression");
        my_show_poly(poly1);
        printf("\nCreate 2nd expression\n");
        my_create_poly(&poly2);
        printf("\nStored the 2nd expression");
        my_show_poly(poly2);
        my_add_poly(&poly3, poly1, poly2);
        my_show_poly(poly3);
        printf("\nAdd two more expressions? (Y = 1/N = 0): ");
        scanf("%d", &ch);
    } while (ch);
    return 0;
}
 void my_create_poly(my_poly ** node) {
    int flag; 
    int coeff, pow;
    my_poly * tmp_node; 
    tmp_node = (my_poly *) malloc(sizeof(my_poly));
    *node = tmp_node; 
    do {
        printf("\nEnter Coeff:");
        scanf("%d", &coeff);
        tmp_node->coeff = coeff;
        printf("\nEnter Pow:");
        scanf("%d", &pow);
        tmp_node->pow = pow;
        tmp_node->next = NULL;
        printf("\nContinue adding more terms to the polynomial list?(Y = 1/N = 0): ");
        scanf("%d", &flag);
        if(flag) {
            tmp_node->next = (my_poly *) malloc(sizeof(my_poly)); 
            tmp_node = tmp_node->next;
            tmp_node->next = NULL;
        }
    } while (flag);
}
void my_show_poly(my_poly * node) {
    printf("\nThe polynomial expression is:\n");
    while(node != NULL) {
        printf("%dx^%d", node->coeff, node->pow);
        node = node->next;
        if(node != NULL)
            printf(" + ");
    }
}
void my_add_poly(my_poly ** result, my_poly * poly1, my_poly * poly2) {
    my_poly * tmp_node;
    tmp_node = (my_poly *) malloc(sizeof(my_poly));
    tmp_node->next = NULL;
    *result = tmp_node; 
    while(poly1 && poly2) {
        if (poly1->pow > poly2->pow) {
            tmp_node->pow = poly1->pow;
            tmp_node->coeff = poly1->coeff;
            poly1 = poly1->next;
        }
        else if (poly1->pow < poly2->pow) {
            tmp_node->pow = poly2->pow;
            tmp_node->coeff = poly2->coeff;
            poly2 = poly2->next;
        }
        else {
            tmp_node->pow = poly1->pow;
            tmp_node->coeff = poly1->coeff + poly2->coeff;
            poly1 = poly1->next;
            poly2 = poly2->next;
        }
        if(poly1 && poly2) {
            tmp_node->next = (my_poly *) malloc(sizeof(my_poly));
            tmp_node = tmp_node->next;
            tmp_node->next = NULL;
        }
    }
    while(poly1 || poly2) {
        tmp_node->next = (my_poly *) malloc(sizeof(my_poly));
        tmp_node = tmp_node->next;
        tmp_node->next = NULL;
        if(poly1) {
            tmp_node->pow = poly1->pow;
            tmp_node->coeff = poly1->coeff;
            poly1 = poly1->next;
        }
        if(poly2) {
            tmp_node->pow = poly2->pow;
            tmp_node->coeff = poly2->coeff;
            poly2 = poly2->next;
        }
    }
    printf("\nAddition Complete");

//9

#include <stdio.h>
#include <stdlib.h>
typedef struct node *nodepointer;
typedef struct node {
    nodepointer llink;
    int data;
    nodepointer rlink;
} Node;
void dinsert(nodepointer node, nodepointer newnode) {
    newnode->llink = node;
    newnode->rlink = node->rlink;
    if (node->rlink != NULL)
        node->rlink->llink = newnode;
    node->rlink = newnode;
}
void delete(nodepointer deleted) {
    if (deleted->llink != NULL)
        deleted->llink->rlink = deleted->rlink;
    if (deleted->rlink != NULL)
        deleted->rlink->llink = deleted->llink;
    free(deleted);
}
void display(nodepointer header) {
    nodepointer current = header->rlink;
    if (current == NULL) {
        printf("List is empty\n");
        return;
    }
    printf("List: ");
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->rlink;
    }
    printf("\n");
}
int main(void) {
    nodepointer header = (nodepointer)malloc(sizeof(Node));
    header->llink = header->rlink = NULL;
    int choice;
    int item;
    while (1) {
        printf("Enter\n 1. Insert\n 2. Delete\n 3. Display\n 4. Exit\n");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                printf("Enter data to be inserted: ");
                scanf("%d", &item);
                nodepointer newnode = (nodepointer)malloc(sizeof(Node));
                newnode->data = item;
                dinsert(header, newnode);
                break;
            case 2:
                if (header->rlink == NULL) {
                    printf("List is empty. Cannot delete.\n");
                    break;
                }
                printf("Enter data to be deleted: ");
                scanf("%d", &item);
                nodepointer current = header->rlink;
                while (current != NULL && current->data != item) {
                    current = current->rlink;
                }
                if (current == NULL) {
                    printf("Element not found in the list\n");
                } else {
                    delete(current);
                    printf("Element deleted: %d\n", item);
                }
                break;
            case 3:
                display(header);
                break;
            case 4:
                free(header);
                exit(0);
            default:
                printf("Invalid choice\n");
        }
    }
    return 0;
}


//10

#include <stdio.h>
#include <stdlib.h>
struct tree {
    int data;
    struct tree *rlink;
    struct tree *llink;
};
typedef struct tree * treeptr;
void insert(treeptr *root, int item) {
    if (!(*root)) {
        *root = (treeptr)malloc(sizeof(struct tree));
        (*root)->data = item;
        (*root)->llink = NULL;
        (*root)->rlink = NULL;
        return;
    }
    else if ((*root)->data > item)
        insert(&(*root)->llink, item);
    else if ((*root)->data < item)
        insert(&(*root)->rlink, item);
}
void inorder(treeptr root) {
    if (root) {
        inorder(root->llink);
        printf("%d\t", root->data);
        inorder(root->rlink);
    }
}
void preorder(treeptr root) {
    if (root) {
        printf("%d\t", root->data);
        preorder(root->llink);
        preorder(root->rlink);
    }
}
void postorder(treeptr root) {
    if (root) {
        postorder(root->llink);
        postorder(root->rlink);
        printf("%d\t", root->data);
    }
}
void search(treeptr root, int item) {
    if (root == NULL) {
        printf("\nNot found");
        return;
    }
    else if (root->data == item) {
        printf("\nFound");
        return;
    }
    else if (root->data > item)
        search(root->llink, item);
    else if (root->data < item)
        search(root->rlink, item);
}
int main() {
    int ch, item;
    treeptr root;
    root = NULL;
    while (1) {
        printf("\n1.Insert\n2.InOrder\n3.PreOrder\n4.PostOrder\n5.Search\n6.Exit\n");
        scanf("%d", &ch);
        switch (ch) {
        case 1:
            printf("\nEnter element to be inserted:\t");
            scanf("%d", &item);
            insert(&root, item);
            break;
        case 2:
            printf("\nIn-order Traversal: ");
            inorder(root);
            break;
        case 3:
            printf("\nPre-order Traversal: ");
            preorder(root);
            break;
        case 4:
            printf("\nPost-order Traversal: ");
            postorder(root);
            break;
        case 5:
            printf("\nEnter element to be searched: ");
            scanf("%d", &item);
            search(root, item);
            break;
        case 6:
            exit(1);
        }
    }
    return 0;
}


/11

#include<stdio.h>
#include<stdlib.h>
#define MAX_SIZE 10
typedef struct {
    int key;
} element;
element heap[MAX_SIZE];
void insert(element item, int *n) {
    int i;
    if ((*n) == MAX_SIZE - 1) {
        printf("Heap Full\n");
        return;
    }
    i = ++(*n);
    while (i != 1 && item.key > heap[i / 2].key) {
        heap[i] = heap[i / 2];
        i /= 2;
    }
    heap[i] = item;
}
element deleteHeap(int* n) {
    int parent, child;
    element temp, item;
    if (*n == 0) {
        printf("Heap Empty\n");
        item.key = -1;
        return item;
    }
    item = heap[1];
    temp = heap[(*n)--];
    parent = 1;
    child = 2;
    while (child <= *n) {
        if (child < *n && heap[child].key < heap[child + 1].key) 
            child++;
        if (temp.key >= heap[child].key)
            break;
        heap[parent] = heap[child];
        parent = child;
        child = child * 2;
    }
    heap[parent] = temp;
    return item;
}
void display(int n) {
    int i;
    for (i = 1; i <= n; i++) {
        printf("%d\n", heap[i].key);
    }
}
int main() {
    int choice, n = 0;
    element item;
    while (1) {
        printf("Enter\n 1. Insert\n 2. Display\n 3. Delete\n 4. Exit");
        scanf("%d", &choice);
        switch (choice) {
            case 1:
                printf("Enter element to insert");
                scanf("%d", &item.key);
                insert(item, &n);
                break;
            case 2:
                display(n);
                break;
            case 3:
                item = deleteHeap(&n);
                if (item.key != -1)
                    printf("Element Deleted: %d\n", item.key);
                break;
            case 4:
                exit(0);
        }
    }
    return 0;
}


//12

#include<stdio.h>
#include<stdlib.h>
#define MAX 200
typedef struct node
{
    struct node *next;
    int vertex;
} node;
void readgraph();
void insert(int vi,int vj);
void DFS(int i);
void BFS(int i);
int visited[MAX];
node *G[20];
int n;
void main()
{
    int i, op;
    do
    { 
        printf("\n\n1)Create\n2)DFS\n3)BFS\n4)Quit");
        printf("\nEnter Your Choice: ");
        scanf("%d", &op);
        switch (op)
        { 
            case 1: readgraph(); 
          break;
            case 2: 
                for (i = 0; i < n; i++)
                    visited[i] = 0;
                printf("\nStarting Node No. : ");
                scanf("%d", &i);
                DFS(i);
                break;
            case 3: 
                for (i = 0; i < n; i++)
                    visited[i] = 0;
                printf("\nStarting Node No. : ");
                scanf("%d", &i);
                BFS(i);
                break;
        }
    } while (op != 4);
}
void DFS(int i)
{
    node *p;
    visited[i] = 1;
    printf("\n%d", i);
    for (p = G[i]; p; p = p->next)
        if (!visited[p->vertex])
            DFS(p->vertex);
}
void BFS(int i)
{
    int queue[MAX], front = -1, rear = -1, v;
    node *p;
    queue[++rear] = i;
    visited[i] = 1;
    printf("\n%d", i);
    while (front != rear)
    {
        v = queue[++front];
        for (p = G[v]; p; p = p->next)
        {
            if (!visited[p->vertex])
            {
                queue[++rear] = p->vertex;
                visited[p->vertex] = 1;
                printf("\n%d", p->vertex);
            }
        }
    }
}
void readgraph()
{ 
    int i, vi, vj, no_of_edges;
    printf("\nEnter no. of vertices :");
    scanf("%d", &n);
    for (i = 0; i < n; i++)
        G[i] = NULL;
    printf("\nEnter no of edges :");
    scanf("%d", &no_of_edges);
    for (i = 0; i < no_of_edges; i++)
    {
        printf("\nEnter an edge (u,v) :");
        scanf("%d%d", &vi, &vj);
        insert(vi, vj);
        insert(vj, vi);
    }
}
void insert(int vi,int vj)
{
    node *p,*q;
    q = (node *)malloc(sizeof(node));
    q->vertex = vj;
    q->next = NULL;
    if (G[vi] == NULL)
        G[vi] = q;
    else
    {
        p = G[vi];
        while (p->next != NULL)
            p = p->next;
        p->next = q;
    }
}
