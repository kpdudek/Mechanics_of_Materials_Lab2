function Torsion_Lab

load = [20,40,60,80,100,120]; %mass added to pulley in g

% Angular displacement data in degrees
ss = [1.5,3.1,4.5,6.1,7.6,9.2];
ss_off = 0;
al = [4.1,8.3,12.6,16.4,20.4,24.7];
al_off = 0;
br = [3.3,6.5,9.6,12.7,15.8,18.8];
br_off = -.1;

ss = offset(ss,ss_off);
al = offset(al,al_off);
br = offset(br,br_off);

function out = offset(vec,off)
out = vec - off;

function rad = deg_to_rad(deg)
rad = deg .* pi ./ 180;








