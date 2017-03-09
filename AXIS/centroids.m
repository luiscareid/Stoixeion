function [ XY_coords ] = centroids( CONTS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N=length(CONTS);   %centros

    for j=1:N
    a{j}=mean(CONTS{j});
    end
XY_coords=cell2mat(a');

%abrir y salvar las coordenas en un archivo de texto normal

