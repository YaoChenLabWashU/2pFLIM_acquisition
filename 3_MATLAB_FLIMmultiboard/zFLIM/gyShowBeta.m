function gyShowBeta(beta0)
global spc
b=beta0(:);
gya=spc.datainfo.psPerUnit/1000;
disp(num2str(b'.*[1 gya 1 gya gya gya],'%12.4f'));
