const fragment = document.createDocumentFragment();
const listURL = `http://localhost:4567/tests`;
const token = '';
const searchURL = `http://localhost:4567/tests/${token}`;
const importURL = `http://localhost:4567/import`;
const searchInput = document.getElementById('search-input');
const searchButton = document.getElementById('search-button');
const listButton = document.getElementById('list-button');
const importButton = document.getElementById('import-button');

listButton.addEventListener('click', function () {
  clearYeld();
  showList(listURL);
});

searchButton.addEventListener('click', function () {
  clearYeld();
  const searchToken = searchInput.value;
  showList(searchURL + searchToken);
});

importButton.addEventListener('click', function (event) {
  event.preventDefault();
  clearYeld();
  const importForm = document.createElement('form');
  const fileInput = document.createElement('input');
  const sendFileButton = document.createElement('button');
  fileInput.type = 'file';
  sendFileButton.type ='submit';
  sendFileButton.textContent = 'Upload file';
  importForm.id = 'import-form';
  fileInput.id = 'import-file-input';
  sendFileButton.id = 'import-send-file-button';
  importForm.appendChild(fileInput);
  importForm.appendChild(sendFileButton);
  document.querySelector('#yeld').appendChild(importForm);
  uploadFile();
});

function showList(source) {
  fetch(source).
    then((response) => response.json()).
    then((data) => populateList(data)).
    then(() => {
      document.querySelector('#yeld').appendChild(fragment);
    }).
    catch(function (error) {
      console.log(error);
    });
};

function populateList(data) {
  if (data.results){
    data.results.forEach(function (result) {
      const li = document.createElement('li');
      addClass(li, 'list-item');
      appendElement('span', result.result_token, li, 'short-text-component', "token");
      appendElement('span', result.result_date, li, 'short-text-component', "exam date:");
      li.addEventListener('click', function () {
        showDetails(result, li);
      });
      fragment.appendChild(li);
    })
  }
}

function uploadFile() {
  const form = document.querySelector('#import-form');
  form.addEventListener('submit', function (event) {
    event.preventDefault();
    const file = document.getElementById('import-file-input').files[0];
    const formData = new FormData();
    formData.append('file', file);
    fetch(importURL, { method: 'POST', body: formData })
      .then(response => {
        if (response.ok) {
          alert('Your file is being processed');
        } else {
          throw new Error('Something went wrong');
        }
      })
      .catch(error => {
        console.error('Error during upload process', error);
        alert('Something went wrong');
      });
  });
}

function showDetails(result, container) {
  if (!container.classList.contains('selected')) {
    hideAll('.details');
  }
  if (container.nextElementSibling && container.nextElementSibling.classList.contains('details')) {
    let detailsDiva = container.nextElementSibling;
    detailsDiva.style.display = detailsDiva.style.display === 'none' ? 'block' : 'none';
  } else {
    detailsDiv = document.createElement('div');
    detailsDiv.classList.add('details');
    appendElement('p', result.name.toUpperCase(), detailsDiv, "patient:");
    appendElement('p', result.doctor.name.toUpperCase(), detailsDiv, "doctor:");
    appendTable(result.tests, 'test', ['test', 'limits', 'result'], detailsDiv, "tests:");
    container.after(detailsDiv);
    detailsDiv.style.display = 'block';
  }
  container.classList.toggle('selected');
}

function hideAll(selector) {
  const elements = document.querySelectorAll(selector);
  elements.forEach(element => {
    if (element.style.display === 'block') {
      element.style.display = 'none';
      element.previousElementSibling.classList.remove('selected');
    }
  });
}

function appendElement(elementType, text, target, aclass = null, label = null) {
  const element = document.createElement(elementType);
  addClass(element, `${aclass}`);
  if (label) {
    element.textContent = `${label} ${text}`;
  } else {
    element.textContent = text;
  }
  target.appendChild(element);
}

function appendTable(list, item, item_params, target) {
  const table = document.createElement('table');
  addClass(table, 'short-table');
  list.forEach(function (item) {
    const tr = document.createElement('tr');
    item_params.forEach(function (param) {
      appendElement('td', item[param].toUpperCase(), tr, `${param}:`)
    }),
      table.appendChild(tr);
  }),
    target.appendChild(table);
}

function addClass(element, className) {
  if (element.classList) {
    element.classList.add(className);
  } else {
    element.className += ' ' + className;
  }
}

function clearYeld(elementId = '#yeld') {
  const deletable_element = document.querySelector(elementId);
  /*deletable_elements.forEach(item => item.remove());*/
  deletable_element.innerHTML = '';
}