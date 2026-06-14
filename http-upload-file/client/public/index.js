function uploadFile(file, name) {
    console.log('upload file', name);
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'http://localhost:5005/upload-file', true);

    xhr.setRequestHeader('Accept', 'application/json');

    const formData = new FormData();
    formData.append('files', file, name);

    if (xhr.upload) {
        xhr.upload.onprogress = (event) => {
            const percent = Math.floor((event.loaded / event.total) * 100);
            console.log('progress', percent, '%');
        }
    }

    xhr.onload = () => {
        if (xhr.status === 201 && xhr.readyState === 4) {
            const response = JSON.parse(xhr.response);
            console.log('xhr success response', response);
        }
    }

    xhr.onerror = () => {
        if (xhr.readyState === 4 && xhr.responseText.length !== 0) {

        } else {

        }
    }

    xhr.send(formData);
}

function uploadMultipart(e) {
    e.preventDefault();
    const files = e.target.inputMultipleFiles.files;
    console.log('upload multiple part',files);
    if (files) {
        for (let i = 0; i < files.length; ++i) {
            uploadFile(files[i], files[i].name);
        }

    }

}

window.addEventListener('DOMContentLoaded', (event) => {
    const multipleFilesForm = document.getElementById('multipleFiles')

    multipleFilesForm.addEventListener('submit', uploadMultipart);
});
