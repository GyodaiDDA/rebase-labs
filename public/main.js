const fragment = document.createDocumentFragment();
const list_url = `http://localhost:4567/tests`;
const token = '';
const token_url = `http://localhost:4567/tests/${token}`;
const searchInput = document.getElementById('search-input');
const searchButton = document.getElementById('search-button');
const listButton = document.getElementById('list-button');

listButton.addEventListener('click', showList);

searchButton.addEventListener('click', function() {
  console.log('search button clicked');
  const searchToken = searchInput.value;
  searchData(searchToken);
});


  function showList() {
    fetch(list_url).
      then((response) => response.json()).
      then((data) => populateList(data)).
      then(() => {
        document.querySelector('ul').appendChild(fragment);
      }).
      catch(function(error) {
        console.log(error);
      });
  };

  function populateList(data) {
    data.results.forEach(function(result) {
      const li = document.createElement('li');
      li.classList.add('list-item');
      appendElement('span', result.result_token, li, 'short-text-component', "token");
      appendElement('span', result.result_date, li, 'short-text-component', "exam date:");
      li.addEventListener('click', function() {
        showDetails(result, li);
      });
      fragment.appendChild(li);
    })
  }

  function searchData(token) {
  fetch(`${token_url}${token}`).
    then((response) => response.json()).
    then((data) => {
      console.log(data)
      data.results.forEach(function(result) {
        const li = document.createElement('li');
        li.classList.add('list-item');
        appendElement('div', '', li);
        appendElement('span', result.result_token, li, 'short-text-component', "token");
        appendElement('span', result.result_date, li, 'short-text-component', "exam date:");
        li.addEventListener('click', function() {
          showDetails(result, li);
        });
        fragment.appendChild(li);
      })
    }).
    then(() => {
      document.querySelector('ul').appendChild(fragment);
    }).
    catch(function(error) {
      console.log(error);
    });
};

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
    table.classList.add('short-table');
    list.forEach(function(item){
      const tr = document.createElement('tr');
      item_params.forEach(function(param) {
        appendElement('td',item[param].toUpperCase(), tr, `${param}:`)
      }),      
      table.appendChild(tr);
    }),
    target.appendChild(table);
  }


  function showDetails(result, container) {
    if (!container.classList.contains('selected')) {
      hideAll('.details');
    }
    if (container.nextElementSibling.classList.contains('details')) {
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

  function addClass(element, className) {
    if (element.classList) {
        element.classList.add(className);
    } else {
        element.className += ' ' + className;
    }
  }