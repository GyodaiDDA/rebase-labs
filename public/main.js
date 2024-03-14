const fragment = document.createDocumentFragment();
const listURL = `http://localhost:4567/tests`;
const token = '';
const searchURL = `http://localhost:4567/tests/${token}`;
const searchInput = document.getElementById('search-input');
const searchButton = document.getElementById('search-button');
const listButton = document.getElementById('list-button');

listButton.addEventListener('click', function() {
  showList(listURL);
});

searchButton.addEventListener('click', function() {
  const searchToken = searchInput.value;
  showList(searchURL + searchToken);
});


function showList(source) {
  clearList();
  fetch(source).
    then((response) => response.json()).
    then((data) => populateList(data)).
    then(() => {
      document.querySelector('ul').appendChild(fragment);
    }).
    catch(function(error) {
      console.log(error);
    });
};

function clearList() {
  const details = document.querySelectorAll('.details');
  details.forEach(item => item.remove());
  const listItems = document.querySelectorAll('.list-item');
  listItems.forEach(item => item.remove());
}

function populateList(data) {
  data.results.forEach(function(result) {
    console.log(result);
    const li = document.createElement('li');
    addClass(li,'list-item');
    appendElement('span', result.result_token, li, 'short-text-component', "token");
    appendElement('span', result.result_date, li, 'short-text-component', "exam date:");
    li.addEventListener('click', function() {
      showDetails(result, li);
    });
    fragment.appendChild(li);
  })
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
    appendTable(result.tests, 'test', ['test', 'limits','result'], detailsDiv, "tests:");
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

function appendElement(elementType, text, target, aclass = null, label = null){
  const element = document.createElement(elementType);
  addClass(element,`${aclass}`);
  if (label) {
    element.textContent = `${label} ${text}`;
  } else {
    element.textContent = text;
  }
  target.appendChild(element);
}

function appendTable(list, item, item_params, target){
  const table = document.createElement('table');
  addClass(table,'short-table');
  list.forEach(function(item){
    const tr = document.createElement('tr');
    item_params.forEach(function(param) {
      appendElement('td',item[param].toUpperCase(), tr, `${param}:`)
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