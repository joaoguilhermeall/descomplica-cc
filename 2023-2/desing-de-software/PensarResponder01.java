import java.time.LocalDate;
import java.util.Map;
import java.util.UUID;

public class PensarResponder01 {
    public static void main(String[] args) {
        
    }
}

/**
 * Define uma Pessoa qualquer no processo
 */
class Usuario {
    String cpf;
    String nome;
    String email;
}

/**
 * Define um Cliente no Processo
 */
class Cliente extends Usuario {

    void emitirCertificado(Processo processo) {
        if (processo.status == Processo.Status.DEFERIDO) {
            System.out.println("Processo deferido. Certificado emitido...");
        } else {
            System.out.println("Processo indeferido. Certificado não pode ser emitido...");
        }
    }
}

/**
 * Define o profissional que trabalha na Empresa de Registro de Certificados
 */
class Profissional extends Usuario {
    String matricula;

    void analisarProceso(Processo processo) {
        System.out.println("Analisando processo...");

        processo.responsavelAnalise = this;
        processo.dataAnalise = LocalDate.now();
    }

    void deferirProcesso(Processo processo) {
        processo.status = Processo.Status.DEFERIDO;
    }

    void indeferirProcesso(Processo processo) {
        processo.status = Processo.Status.INDEFERIDO;
    }
}

/**
 * Define um Processo Iniciado pelo Cliente
 */
class Processo {
    String protocolo;
    // Informações do nome do autor e cpf do autor
    Cliente cliente;
    String tituloTrabalho;
    LocalDate dataProducao;

    // Profinssional que realizou a análise do processo
    Profissional responsavelAnalise;
    LocalDate dataAnalise;
    Status status;

    enum Status {
        DEFERIDO, INDEFERIDO
    }

    void deferir() {
        this.status = Status.DEFERIDO;
    }

    void indeferir() {
        this.status = Status.INDEFERIDO;
    }
}

class RegistroProcessos {
    String nome;
    String cnpj;
    Map<String, Processo> processos;

    private String novoProtocolo() {
        return UUID.randomUUID().toString();
    }

    /**
     * Registra um processo e retorna o protocolo atribuído
     * @param processo
     * @return String (protocolo do processo registrado)
     */
    String registrarProcesso(Processo processo) {
        String protocolo = this.novoProtocolo();
        processo.protocolo = protocolo;

        processos.put(protocolo, processo);

        return protocolo;
    }

    /**
     * Consulta um processo através do protocolo passado via parâmetro
     * @param protocolo
     * @return {@link Processo}
     */
    Processo consultarProcesso(String protocolo) {
        return this.processos.get(protocolo);

    }
}
