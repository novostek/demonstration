import React from 'react'

const ProductItem = ({estimate}) => {
  return (
    <div className="row products-area-list pl-1 pr-1" id="measurement_proposals">
      <div className="product-area">
        <a href="#" className="btn-close-product-area"><i className="material-icons">close</i></a>
        <div className="areas-available col s12">
          <span>Areas:</span>
          {
            estimate.measurement_areas.data.map(ma => (
              <div className="chip" key={ma.id}>{ma.name}</div>
            ))
          }
          <a href="#" className="select-all-areas">Select all</a>
        </div>
        <div className="products-list">
          <div className="product">
            <div className="row pl-1 pr-1 products-search">
              <div className="row">
                <div className="col s6 m4">
                  <span className="left width-100 pt-1">Product</span>
                  <div className="input-field mt-0 mb-0 products-search-field-box">
                    <a href="#" className="btn-add-product tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a>
                    <input placeholder="" autoComplete="off" id="title" type="text" className="autocomplete autocomplete-products mt-1" />
                  </div>
                </div>
                <div className="col s6 m2 calc-fields">
                  {/* <%#= f.span :quantity, "Qty.", class: "left width-100 pt-1" %> */}
                  <span className="left width-100 pt-1">Qty.</span>
                  <input type="text" name="quantity" id="quantity" className="product-value qty" />
                </div>
                <div className="col s6 m2 calc-fields">
                  <span className="left width-100 pt-1">Prince un.</span>
                  <input type="text" name="price" id="price" className="product-value price" />
                  {/* <%= f.text_field :unitary_value, class: "product-value price" %> */}
                </div>
                <div className="col s6 m2 calc-fields">
                  {/* <%#= f.label :discount, "Discount", class: "left width-100 pt-1" %> */}
                  <span className="left width-100 pt-1">Discount</span>
                  <input type="text" name="discount" id="discount" className="product-value discount" />
                  {/* <%= f.text_field :discount, class: "product-value discount" %> */}
                </div>
                <div className="col s6 m2 calc-fields">
                  {/* <%#= f.label :value, "Total", class: "left width-100 pt-1" %> */}
                  <span className="left width-100 pt-1">Total</span>
                  <input type="text" name="total" id="total" className="product-value total" />
                  {/* <%= f.text_field :value, class: "product-value total" %> */}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductItem
