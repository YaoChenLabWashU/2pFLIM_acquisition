function LoadLibrary(library_name, library_header_file);

if (~libisloaded(library_name))
    loadlibrary(library_name, library_header_file);
end
