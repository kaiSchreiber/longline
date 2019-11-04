program longline;

uses
  Forms,
  main in 'main.pas' {FormMain},
  options in 'options.pas' {FormOptions},
  reject in 'reject.pas' {FormReject},
  progress in 'progress.pas' {FormProgress},
  saveoptions in 'saveoptions.pas' {FormSaveOptions},
  designer in 'designer.pas' {FormDesign},
  colortally in 'colortally.pas' {FormTally};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Longline';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.CreateForm(TFormReject, FormReject);
  Application.CreateForm(TFormProgress, FormProgress);
  Application.CreateForm(TFormSaveOptions, FormSaveOptions);
  Application.CreateForm(TFormDesign, FormDesign);
  Application.CreateForm(TFormTally, FormTally);
  Application.Run;
end.
