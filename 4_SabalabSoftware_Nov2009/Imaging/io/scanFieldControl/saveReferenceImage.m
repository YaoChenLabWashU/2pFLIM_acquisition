function saveReferenceImage

global state;

fname=[state.files.fullFileName '_ref.tif'];

saveas(state.internal.refFigure, fname);