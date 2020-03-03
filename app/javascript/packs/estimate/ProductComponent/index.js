import React from 'react'
import ReactDOM from 'react-dom'
import EstimateDetail from '../EstimateDetail'

const ProductComponent = () => {
  const node = document.getElementById('estimate_data')
  const {estimate} = JSON.parse(node.getAttribute('data'))
  console.log(estimate)

  return (
    <div className="row">
      <div className="col s12">
        <div className="container">
          <EstimateDetail estimate={estimate} />
          <div className="card">
            <div className="card-content">
              <ul className="stepper horizontal stepper-head-only">
                <li className="step">
                  <div className="step-title waves-effect">Step 1</div>
                </li>
                <li className="step ">
                  <div className="step-title waves-effect">Schedule</div>
                </li>
                <li className="step">
                  <div className="step-title waves-effect">Measurements</div>
                </li>
                <li className="step active">
                  <div className="step-title waves-effect">Products</div>
                </li>
              </ul>

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
                                <a href="#add-product-modal" class="btn-add-product modal-trigger tooltipped" data-tooltip="New product"><i class="material-icons">add</i></a>
                                <input placeholder="" autoComplete="off" id="title" type="text" className="autocomplete autocomplete-products mt-1"/>
                              </div>
                            </div>
                            <div className="col s6 m2 calc-fields">
                              {/* <%#= f.span :quantity, "Qty.", class: "left width-100 pt-1" %> */}
                              <span className="left width-100 pt-1">Qty.</span>
                              <input type="text" name="quantity" id="quantity" className="product-value qty"/>
                            </div>
                            <div className="col s6 m2 calc-fields">
                              <span className="left width-100 pt-1">Prince un.</span>
                              <input type="text" name="price" id="price" className="product-value price"/>
                              {/* <%= f.text_field :unitary_value, class: "product-value price" %> */}
                            </div>
                            <div className="col s6 m2 calc-fields">
                              {/* <%#= f.label :discount, "Discount", class: "left width-100 pt-1" %> */}
                              <span className="left width-100 pt-1">Discount</span>
                              <input type="text" name="discount" id="discount" className="product-value discount"/>
                              {/* <%= f.text_field :discount, class: "product-value discount" %> */}
                            </div>
                            <div className="col s6 m2 calc-fields">
                              {/* <%#= f.label :value, "Total", class: "left width-100 pt-1" %> */}
                              <span className="left width-100 pt-1">Total</span>
                              <input type="text" name="total" id="total" className="product-value total"/>
                              {/* <%= f.text_field :value, class: "product-value total" %> */}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>

                  <div className="row mt-1">
                    <a href="#" className="btn btn-add-product-area"><i className="material-icons left">add</i> Add area</a>
                  </div>
                </div>

              <div className="products-suggestions hide">
                <h6 className="suggestions-title">Suggestions</h6>
                <a href="#" data-price="56.9" data-qty="3">Product with a big name</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y2</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y3</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y5</a>
              </div>
            </div>

          </div>
          <div className="col s12 pb-2 pr-0 pl-0" style={{position: 'relative', zIndex: -1}}>
            <a className="btn grey lighten-5 grey-text waves-effect waves-light breadcrumbs-btn left save" href="estimate-measurements.html"><i className="material-icons left">arrow_back</i> Back</a>
            <a className="btn indigo waves-effect waves-light breadcrumbs-btn right ml-1" href="estimate-view.html"><i className="material-icons left">save</i> Save</a>
          </div>
        </div>
      </div>
    </div>
  )
}

// export default ProductComponent
document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ProductComponent />,
    document.getElementById('react-component'),
  )
})

