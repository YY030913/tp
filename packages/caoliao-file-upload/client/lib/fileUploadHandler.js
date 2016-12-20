/* globals FileUpload, fileUploadHandler:true */
/* exported fileUploadHandler */

fileUploadHandler = (meta, file) => {
	var storageType = CaoLiao.settings.get('FileUpload_Storage_Type');

	if (FileUpload[storageType] !== undefined) {
		return new FileUpload[storageType](meta, file);
	}
};
