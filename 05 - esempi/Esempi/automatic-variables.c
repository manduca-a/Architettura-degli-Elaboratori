#include <stdio.h>

int main(void) {
    const int n = 3;
    
    int arr[n];
    for(int i = 0; i < n; i++) {
        printf("arr[%d]: ", i);
        scanf("%d", &arr[i]);
    }
    
    int sum = 0;
    for(int i = 0; i < n; i++) {
        sum += arr[i];
    }
    printf("sum = %d\n", sum);

    return 0;
}
