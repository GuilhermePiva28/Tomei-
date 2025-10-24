// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Tomei?';

  @override
  String get myCalendar => 'Meu Calendário';

  @override
  String get myMedications => 'Meus Medicamentos';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get portuguese => 'Português (BR)';

  @override
  String get english => 'English';

  @override
  String get addMedication => 'Adicionar Medicamento';

  @override
  String get editMedication => 'Editar Medicamento';

  @override
  String get medicationName => 'Nome do Medicamento';

  @override
  String get dosageValue => 'Valor da Dosagem';

  @override
  String get dosageUnit => 'Unidade da Dosagem';

  @override
  String get firstDoseTime => 'Horário da Primeira Dose';

  @override
  String get enableNotifications => 'Ativar Notificações e Alarme';

  @override
  String get intervalType => 'Tipo de Intervalo';

  @override
  String get daily => 'Diário';

  @override
  String get everyXDays => 'A Cada X Dias';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get custom => 'Personalizado';

  @override
  String get timesPerDay => 'Vezes por Dia';

  @override
  String get intervalDays => 'Intervalo (Dias)';

  @override
  String get startDate => 'Data de Início';

  @override
  String get selectWeekdays => 'Selecionar Dias da Semana';

  @override
  String get dayOfMonth => 'Dia do Mês';

  @override
  String get customInterval => 'Intervalo Personalizado (Horas)';

  @override
  String get notes => 'Observações (Opcional)';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get taken => 'Tomei';

  @override
  String get skip => 'Pular';

  @override
  String get scheduled => 'Agendado';

  @override
  String get skipped => 'Pulado';

  @override
  String get noMedications => 'Nenhum medicamento cadastrado';

  @override
  String get noMedicationsDescription =>
      'Toque em + para adicionar seu primeiro medicamento';

  @override
  String get confirmDelete => 'Confirmar Exclusão';

  @override
  String get confirmDeleteMessage =>
      'Tem certeza que deseja excluir este medicamento?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get timeToTake => 'Hora de tomar';

  @override
  String get notificationTitle => 'Lembrete de Medicamento';

  @override
  String notificationBody(String medicationName, String dosage) {
    return 'Hora de tomar $medicationName — $dosage';
  }

  @override
  String get enableSound => 'Ativar Som';

  @override
  String get enableVibration => 'Ativar Vibração';

  @override
  String get backupData => 'Fazer Backup';

  @override
  String get importData => 'Importar Dados';

  @override
  String get exportSuccess => 'Dados exportados com sucesso';

  @override
  String get importSuccess => 'Dados importados com sucesso';

  @override
  String get exportError => 'Erro ao exportar dados';

  @override
  String get importError => 'Erro ao importar dados';

  @override
  String get appVersion => 'Versão';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get license => 'Licença';

  @override
  String get aboutDescription =>
      'Tomei? ajuda você a lembrar de tomar seus medicamentos com lembretes offline e armazenamento local.';

  @override
  String get adherenceStats => 'Estatísticas de Adesão';

  @override
  String get weeklyAdherence => 'Adesão Semanal';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get tuesday => 'Terça-feira';

  @override
  String get wednesday => 'Quarta-feira';

  @override
  String get thursday => 'Quinta-feira';

  @override
  String get friday => 'Sexta-feira';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get mon => 'Seg';

  @override
  String get tue => 'Ter';

  @override
  String get wed => 'Qua';

  @override
  String get thu => 'Qui';

  @override
  String get fri => 'Sex';

  @override
  String get sat => 'Sáb';

  @override
  String get sun => 'Dom';

  @override
  String get mcg => 'mcg';

  @override
  String get mg => 'mg';

  @override
  String get g => 'g';

  @override
  String get ml => 'ml';

  @override
  String get iu => 'UI';

  @override
  String get tablet => 'comprimido(s)';

  @override
  String get capsule => 'cápsula(s)';

  @override
  String get required => 'Este campo é obrigatório';

  @override
  String get invalidNumber => 'Por favor, insira um número válido';

  @override
  String get selectAtLeastOneDay => 'Selecione pelo menos um dia';

  @override
  String get medicationColor => 'Cor do Medicamento';

  @override
  String get selectColor => 'Selecionar Cor';

  @override
  String get medicationSchedule => 'Horário da Medicação';

  @override
  String get firstDose => 'Primeira Dose';

  @override
  String get secondDose => 'Segunda Dose';

  @override
  String get thirdDose => 'Terceira Dose';

  @override
  String get fourthDose => 'Quarta Dose';

  @override
  String get fifthDose => 'Quinta Dose';

  @override
  String doseNumber(int number) {
    return 'Dose $number';
  }
}
