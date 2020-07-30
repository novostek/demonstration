import React from 'react'

const MeasurementProposal = () => {
  return (
    <div className="row products-area-list pl-1 pr-1 mt-2" id="measurement_proposals" key={index}>
        <div className="product-area">
          {/* <a onClick={() => refreshArea(index)} style={{ cursor: 'pointer' }} key={Math.random} className="btn-refresh-product-area mr-5">Select all</a> */}
          <a onClick={() => refreshArea(index)} style={{ cursor: 'pointer' }} key={Math.random()} className="btn-refresh-product-area"><i className="material-icons">refresh</i></a>
          <a onClick={() => removeArea(index, pe.proposal_id)} style={{ cursor: 'pointer' }} key={Math.random()} className="btn-close-product-area"><i className="material-icons">close</i></a>
          <div className="areas-available col ">
            <span>Itens for: </span>
            {
              estimate.measurement_areas.map((ma, maIndex) => (
                <div className={`chip ${productEstimate[index].areas.includes(ma.id) ? 'selected' : ''}`} key={Math.random()} onClick={() => !productEstimate[index].areas.includes(ma.id) ? selectArea(index, ma.id, true) : selectArea(index, ma.id, false)}>
                  {ma.name}
                </div>
              ))
            }
            {/* <a href="#" className="select-all-areas">Select all</a> */}
          </div>
          <div className="products-list">

            <input type="hidden" ref={register} name={`measurement_area[${index}]`} value={index} />
            {
              pe.products.map((product, peIndex) => (
                <div className="product" key={peIndex}>
                  <div className="row pl-1 pr-1 products-search">
                    <div className="row">
                      <div className="col s6 m3">
                        <span className="left width-100 pt-1">Product</span>
                        <div className="input-field mt-0 mb-0 products-search-field-box">
                          <a href="#product-add-modal" key={Math.random} className="btn-add-product modal-trigger tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a>
                          <input
                            name={`measurement[${index}].products[${peIndex}].name`}
                            ref={register}
                            onFocus={() => updateProductList()}
                            onChange={(e) => handleChange(index, peIndex, e.target.name, e.target.value)}
                            defaultValue={productEstimate[index].products[peIndex].name}
                            readOnly={productEstimate[index].products[peIndex].readOnly}
                            onClick={() => setMaProductListIndex(prev => {
                              return { ...prev, maIndex: index, productIndex: peIndex }
                            })}
                            autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                          <input
                            defaultValue={productEstimate[index].products[peIndex].product_id}
                            name={`measurement[${index}].products[${peIndex}].product_id`}
                            ref={register}
                            autoComplete="off"
                            type="hidden" />
                        </div>
                      </div>
                      <div className="col s6 m2 input-fields">
                        <label >
                          <input
                            name={`measurement[${index}].products[${peIndex}].tax`}
                            ref={register}
                            type="checkbox"
                            onChange={(e) => {
                              const { checked } = e.target
                              setProductEstimate(productEstimate => {
                                const copy = [...productEstimate]
                                console.log(checked)
                                copy[index].products[peIndex].tax = checked

                                return copy
                              })
                            }}
                            defaultChecked={productEstimate[index].products[peIndex].tax}
                          />
                          <span style={{ marginTop: '30px' }} className="left width-10 pt-1">Tax</span>
                        </label>
                      </div>
                      <div className="col s6 m2 calc-fields">
                        <span className="left width-100 pt-1">Qty.</span>
                        <input
                          type="text"
                          name={`measurement[${index}].products[${peIndex}].qty`}
                          defaultValue={productEstimate[index].products[peIndex].qty}
                          onChange={(e) => productTotalQty(index, peIndex, e.target.value)}
                          ref={register(schema.requiredDecimal)} className="product-value qty" />
                        {errors.qty && <span>{errors.qty.message}</span>}
                      </div>
                      <div className="col s6 m2 calc-fields">
                        <span className="left width-100 pt-1">Price un.</span>
                        <input
                          type="text"
                          name={`measurement[${index}].products[${peIndex}].price`}
                          ref={register(schema.requiredDecimal)}
                          defaultValue={productEstimate[index].products[peIndex].price}
                          onChange={(e) => productTotalPrice(index, peIndex, e.target.value)}
                          className="product-value price" />
                        {errors.price && <span>{errors.price.message}</span>}
                      </div>
                      <div className="col s6 m1 calc-fields">
                        <span className="left width-100 pt-1">Discount</span>
                        <input type="text"
                          name={`measurement[${index}].products[${peIndex}].discount`}
                          defaultValue={productEstimate[index].products[peIndex].discount}
                          onChange={(e) => productTotalDiscount(index, peIndex, e.target.value)}
                          ref={register(schema.requiredDecimal)}
                          className="product-value discount" />
                        {errors.discount && <span>{errors.discount.message}</span>}
                      </div>
                      <div className="col s6 m2 calc-fields">
                        <span className="left width-100 pt-1">Total</span>
                        <input
                          type="text"
                          name={`measurement[${index}].products[${peIndex}].total`}
                          defaultValue={parseFloat(productEstimate[index].products[peIndex].total).toFixed(2)}
                          ref={register(schema.requiredDecimal)}
                          className="product-value total" />
                        <a onClick={() => removeProduct(index, peIndex)} style={{ cursor: 'pointer' }} className="btn-remove-product"><i className="material-icons">delete</i></a>
                        {errors.total && <span>{errors.total.message}</span>}
                      </div>
                    </div>
                  </div>
                </div>
              ))
            }
            <a onClick={() => addProduct(index)} style={{ height: '30px' }} className="product new-product">
            </a>
          </div>
          <div className="products-suggestions mt-2">
            {
              (productEstimate[index].showSuggestions && Array.isArray(suggestions) && suggestions.length > 0)
              &&
              <h6 className="suggestions-title">Suggestions</h6>
            }
            {
              // console.log(suggestions[index])
              (productEstimate[index].showSuggestions && suggestions[index] && Array.isArray(suggestions[index].suggestions))
              &&
              suggestions[index].suggestions.map((suggestion, s_index) => {
                return (
                  <a key={s_index} onClick={() => addSuggestionsToProductList(index, suggestion)} style={{ cursor: 'pointer' }}> {suggestion.name}</a>
                )
              })
            }
          </div>

        </div>
      </div>
  )
}
<div className="row products-area-list pl-1 pr-1 mt-2" id="measurement_proposals" key={index}>
                      <div className="product-area">
                        {/* <a onClick={() => refreshArea(index)} style={{ cursor: 'pointer' }} key={Math.random} className="btn-refresh-product-area mr-5">Select all</a> */}
                        <a onClick={() => refreshArea(index)} style={{ cursor: 'pointer' }} key={Math.random()} className="btn-refresh-product-area"><i className="material-icons">refresh</i></a>
                        <a onClick={() => removeArea(index, pe.proposal_id)} style={{ cursor: 'pointer' }} key={Math.random()} className="btn-close-product-area"><i className="material-icons">close</i></a>
                        <div className="areas-available col ">
                          <span>Areas:</span>
                          {
                            estimate.measurement_areas.map((ma, maIndex) => (
                              <div className={`chip ${productEstimate[index].areas.includes(ma.id) ? 'selected' : ''}`} key={Math.random()} onClick={() => !productEstimate[index].areas.includes(ma.id) ? selectArea(index, ma.id, true) : selectArea(index, ma.id, false)}>
                                {ma.name}
                              </div>
                            ))
                          }
                          {/* <a href="#" className="select-all-areas">Select all</a> */}
                        </div>
                        <div className="products-list">

                          <input type="hidden" ref={register} name={`measurement_area[${index}]`} value={index} />
                          {
                            pe.products.map((product, peIndex) => (
                              <div className="product" key={peIndex}>
                                <div className="row pl-1 pr-1 products-search">
                                  <div className="row">
                                    <div className="col s6 m3">
                                      <span className="left width-100 pt-1">Product</span>
                                      <div className="input-field mt-0 mb-0 products-search-field-box">
                                        <a href="#product-add-modal" key={Math.random} className="btn-add-product modal-trigger tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a>
                                        <input
                                          name={`measurement[${index}].products[${peIndex}].name`}
                                          ref={register}
                                          onFocus={() => updateProductList()}
                                          onChange={(e) => handleChange(index, peIndex, e.target.name, e.target.value)}
                                          defaultValue={productEstimate[index].products[peIndex].name}
                                          readOnly={productEstimate[index].products[peIndex].readOnly}
                                          onClick={() => setMaProductListIndex(prev => {
                                            return { ...prev, maIndex: index, productIndex: peIndex }
                                          })}
                                          autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                                        <input
                                          defaultValue={productEstimate[index].products[peIndex].product_id}
                                          name={`measurement[${index}].products[${peIndex}].product_id`}
                                          ref={register}
                                          autoComplete="off"
                                          type="hidden" />
                                      </div>
                                    </div>
                                    <div className="col s6 m2 input-fields">
                                      <label >
                                        <input
                                          name={`measurement[${index}].products[${peIndex}].tax`}
                                          ref={register}
                                          type="checkbox"
                                          onChange={(e) => {
                                            const { checked } = e.target
                                            setProductEstimate(productEstimate => {
                                              const copy = [...productEstimate]
                                              console.log(checked)
                                              copy[index].products[peIndex].tax = checked

                                              return copy
                                            })
                                          }}
                                          defaultChecked={productEstimate[index].products[peIndex].tax}
                                        />
                                        <span style={{ marginTop: '30px' }} className="left width-10 pt-1">Tax</span>
                                      </label>
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Qty.</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].qty`}
                                        defaultValue={productEstimate[index].products[peIndex].qty}
                                        onChange={(e) => productTotalQty(index, peIndex, e.target.value)}
                                        ref={register(schema.requiredDecimal)} className="product-value qty" />
                                      {errors.qty && <span>{errors.qty.message}</span>}
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Price un.</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].price`}
                                        ref={register(schema.requiredDecimal)}
                                        defaultValue={productEstimate[index].products[peIndex].price}
                                        onChange={(e) => productTotalPrice(index, peIndex, e.target.value)}
                                        className="product-value price" />
                                      {errors.price && <span>{errors.price.message}</span>}
                                    </div>
                                    <div className="col s6 m1 calc-fields">
                                      <span className="left width-100 pt-1">Discount</span>
                                      <input type="text"
                                        name={`measurement[${index}].products[${peIndex}].discount`}
                                        defaultValue={productEstimate[index].products[peIndex].discount}
                                        onChange={(e) => productTotalDiscount(index, peIndex, e.target.value)}
                                        ref={register(schema.requiredDecimal)}
                                        className="product-value discount" />
                                      {errors.discount && <span>{errors.discount.message}</span>}
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Total</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].total`}
                                        defaultValue={parseFloat(productEstimate[index].products[peIndex].total).toFixed(2)}
                                        ref={register(schema.requiredDecimal)}
                                        className="product-value total" />
                                      <a onClick={() => removeProduct(index, peIndex)} style={{ cursor: 'pointer' }} className="btn-remove-product"><i className="material-icons">delete</i></a>
                                      {errors.total && <span>{errors.total.message}</span>}
                                    </div>
                                  </div>
                                </div>
                              </div>
                            ))
                          }
                          <a onClick={() => addProduct(index)} style={{ height: '30px' }} className="product new-product">
                          </a>
                        </div>
                        <div className="products-suggestions mt-2">
                          {
                            (productEstimate[index].showSuggestions && Array.isArray(suggestions) && suggestions.length > 0)
                            &&
                            <h6 className="suggestions-title">Suggestions</h6>
                          }
                          {
                            // console.log(suggestions[index])
                            (productEstimate[index].showSuggestions && suggestions[index] && Array.isArray(suggestions[index].suggestions))
                            &&
                            suggestions[index].suggestions.map((suggestion, s_index) => {
                              return (
                                <a key={s_index} onClick={() => addSuggestionsToProductList(index, suggestion)} style={{ cursor: 'pointer' }}> {suggestion.name}</a>
                              )
                            })
                          }
                        </div>

                      </div>
                    </div>