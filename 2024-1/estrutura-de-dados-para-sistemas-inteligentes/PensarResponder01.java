import java.io.BufferedReader;
import java.io.InputStreamReader;

public class PensarResponder01 {
    public static void main(String[] args) {
        Float numeros[] = new Float[50], media = 0F, soma = 0F;

        BufferedReader stdinReader = new BufferedReader(new InputStreamReader(System.in));

        for (int i = 0; i < numeros.length; i++) {
            do {
                System.out.print(String.format("Digite um número inteiro %s/50: ", i + 1));
                try {
                    numeros[i] = Float.parseFloat(stdinReader.readLine());
                } catch (Exception e) {
                    System.out.println("Número inválido");
                }
            } while (numeros[i] == null);

            soma += numeros[i];
        }

        media = soma / 50;

        System.out.println("A média dos números digitados é: " + media);
    }
}
