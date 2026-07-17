clc
clear
close all

%% Initialization

rootDir = fileparts(mfilename('fullpath'));

oldDir = pwd;
cleanup = onCleanup(@() cd(oldDir));

cd(rootDir)

addpath(genpath(fullfile(rootDir,"helper_functions")))
addpath(genpath(fullfile(rootDir,"database")))
addpath(genpath(fullfile(rootDir,"thermodynamic_modeling_functions")))
addpath(genpath(fullfile(rootDir,"scripts")))

%% Load database

databaseFile = fullfile(rootDir,"database","VLE_DATA_binary.json");

database = jsondecode(fileread(databaseFile));

Comp = discoverComponents(databaseFile);

if isempty(Comp)
    error("No components found.")
end

%% Load model

%% Available models

models = struct(...
    "name", { ...
        "uniquac_gl";
        "uniquac_sep";
        "nrtl"}, ...
    "display", { ...
        "UNIQUAC-gl";
        "UNIQUAC-sep";
        "NRTL"});


%% Show selection

fprintf("Available models:\n")

for i = 1:numel(models)
    fprintf("%d: %s\n",i,models(i).display)
end


%% User input

id = input("Select model: ");


if id < 1 || id > numel(models)
    error("Invalid model selection. Enter model ID")
end


modelName = models(id).name;

fprintf("Selected model: %s\n",models(id).display)

load model_parameters.mat
load modelConfig.mat

antoine = model_parameters.antoine;

gE = model_parameters.(modelName);

config = modelConfig.(modelName);

clear modelConfig

%% FIT Model
systems = prepareSystems(database,Comp);

if input("Fit gE model? (0/1): ")
    run("A_fit_model.m")
end

%% Compute VLE for selected binary system
if input("Want to compute binary VLE? (0/1): ")
    run("B_binary_VLE_computation.m")
end

%% Compute VLE for selected ternary system
if input("Want to compute ternary VLE? (0/1): ")
    run("C_ternary_VLE_computation.m")
end
