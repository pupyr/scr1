int mass[8] = {7,3,5,1,4,8,6,2};
void mergeSort(int* addr, int size){
    if(size>1){
        mergeSort(addr, size/2);
        mergeSort(addr+size/2, size-size/2);
    }
    int i1 = 0;
    int i2 = size/2;
    int i = 0;
    int mass_temp[size];
    while(i1<size/2 || i2<size){
        if (i1==size/2 || i2<size && addr[i1]>addr[i2])
            mass_temp[i++] = addr[i2++];
        else
            mass_temp[i++] = addr[i1++];
    }

    for(int i=0; i<size; i++){
        addr[i] = mass_temp[i];
    }
}

int main(){
    
    mergeSort(mass, 4);
}
