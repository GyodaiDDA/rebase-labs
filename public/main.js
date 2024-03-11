const fragment = document.createDocumentFragment();
const url = 'http://localhost:4567/tests';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.results.forEach(function(result) {
      const li = document.createElement('li');
      appendElement('span', result.result_token, li, "token");
      appendElement('span', result.result_date, li, "exam date:");

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

  function appendElement(elementType, text, target, label = null){
    const element = document.createElement(elementType);
    element.classList.add('short-text-component');
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
    let detailsDiv = container.nextElementSibling;
    if (detailsDiv && detailsDiv.classList.contains('details')) {
      detailsDiv.style.display = detailsDiv.style.display === 'none' ? 'block' : 'none';
      container.classList.toggle('opened');
    } else {
      detailsDiv = document.createElement('div');
      detailsDiv.classList.add('details');
      appendElement('p', result.name.toUpperCase(), detailsDiv, "patient:");
      appendElement('p', result.doctor.name.toUpperCase(), detailsDiv, "doctor:");
      appendTable(result.tests, 'test', ['test', 'limits','result'], detailsDiv, "tests:");
      container.after(detailsDiv);
      container.classList.add('opened');
    }
  }