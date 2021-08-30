function convertToIgor(num)

global state

if(nargin<1)
    num=state.files.fileCounter;
end

nrois=2;
nchans=2;

num_ad=num;
num_ls=num;

cd(state.files.savePath);

for acq=1:num
      try
        in_name=['AD0_' num2str(acq)];
  
        evalin('base', ['load(''' in_name ''');']);

        out_name=[in_name '.itx'];
        exportWave(in_name, out_name);
        killo(in_name);
      catch
         num_ad=num_ad-1;
      end
     try
        for roi=1:nrois
            for chan=1:nchans
               in_name=['c' num2str(chan) 'r' num2str(roi) '_' num2str(acq)];
                evalin('base', ['load(''' in_name ''');']);
        
                out_name=[in_name '.itx'];
                exportWave(in_name, out_name);
                killo(in_name);
            end
        end
    catch
        num_ls=num_ls-1;
    end
end

try
    load 'mynotes'
catch
end
try
    load 'autonotes'
catch
end
try
    saveNotebooksToTxt
catch
end

   
disp(['Found ' num2str(num_ad) ' phys files and ' num2str(num_ls) ' linescans'])
