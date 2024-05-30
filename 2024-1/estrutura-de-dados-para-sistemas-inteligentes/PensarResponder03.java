class BIntNo {
    int valor;
    BIntNo esq, dir;
    
    public BIntNo(int valor) {
        this.valor = valor;
        this.esq = null;
        this.dir = null;
    }
}

class ArvoreBinaria {
    BIntNo raiz;

    public ArvoreBinaria() {
        this.raiz = null;
    }

    public BIntNo inserir(BIntNo arvore, int novoNo) {
        if (arvore == null) {
            return new BIntNo(novoNo);
        } else {
            if (novoNo < arvore.valor) {
                arvore.esq = inserir(arvore.esq, novoNo);
            } else {
                arvore.dir = inserir(arvore.dir, novoNo);
            }
        }
        return arvore;
    }

    public void inserirNo(int novoValor) {
        raiz = inserir(raiz, novoValor);
    }

    public void exibirEsquerdo(BIntNo arv) {
        if (arv != null) {
            exibirEsquerdo(arv.esq);
            System.out.println(arv.valor);
        }
    }

    public void exibirNoEsq() {
        exibirEsquerdo(raiz);
    }

    public void exibirDireito(BIntNo arv) {
        if (arv != null) {
            exibirDireito(arv.dir);
            System.out.println(arv.valor);
        }
    }

    public void exibirNoDir() {
        exibirDireito(raiz);
    }

    public void exibirRaiz() {
        System.out.println("raiz " + raiz.valor);
    }
}

public class PensarResponder03 {
    public static void main(String[] args) {
        int num;
        ArvoreBinaria arv = new ArvoreBinaria();

        for (int i = 0; i < 5; i++) {
            System.out.print("Digite cinco números inteiros (" + (i + 1) + "/5): ");
            num = Integer.parseInt(System.console().readLine());
            arv.inserirNo(num);
        }

        arv.exibirNoEsq();
        arv.exibirRaiz();
        arv.exibirNoDir();
    }
}
