
let instances = ''
let instanceModal = ''

document.addEventListener('DOMContentLoaded', function () {
  var elems = document.getElementById('product_category_id');
  var elemsModal = document.getElementById('category-add-modal');
  var instances = M.FormSelect.init(elems, {});


  instanceModal = M.Modal.init(elemsModal, {})
});

// document.getElementById("estimate_sales_person_id").addEventListener('contentChanged', () => $(this).formSelect())

document.getElementById('new_product_category').addEventListener('submit', (e) => {
  const headers = new Headers({
    "Content-Type": "application/json",
    "Accept": "application/json"
  })
  const fetchConfig = {
    headers
  }

  const category_name = document.getElementById('product_category_name').value

  setTimeout(() => {
    fetch(`/product_categories?q%5Bname_eq%5D=${category_name}`, fetchConfig)
      .then((data) => data.json())
      .then((res) => {
        console.log(res)
        // const newOption = $('<option>').attr('value', res[0].id).text(res[0].name)
        const newOption = document.createElement('option')
        newOption.text = res[0].name
        newOption.value = res[0].id
        newOption.selected = true

        const workers = document.getElementById('product_product_category_id')
        workers.appendChild(newOption)

        M.FormSelect.init(workers)

        // $("#estimate_sales_person_id").append(newOption)

        // $("#estimate_sales_person_id").trigger('contentChanged')

        instanceModal.close()
        document.getElementById('product_category_name').value = ''
      })
  }, 300)
})
