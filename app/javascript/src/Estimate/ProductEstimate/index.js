import React, { useContext } from 'react'
import { EstimateContext } from '../../context/Estimate'

const ProductEstimate = ({product, peIndex, index}) => {
  const {
    productEstimate,
    register,
    schema,
    errors,
    updateProductList,
    setMaProductListIndex,
    handleChange,
    removeProduct
  } = useContext(EstimateContext)

  return (
    <div className="row">
      <div className="col s6 m4">
        <span className="left width-100 pt-1">
          Product
          <div className="switch right">
            <label>
              Tax
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
              <span className="lever"></span>
            </label>
          </div>
        </span>
        <div className="input-field mt-0 mb-0 products-search-field-box">
          <a href="#product-add-modal" className="btn-add-product modal-trigger tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a>
          <input
            name={`measurement[${index}].products[${peIndex}].name`}
            ref={register}
            onFocus={() => {
              updateProductList()
              setMaProductListIndex(prev => {
                const copy = {...prev}
  
                copy.maIndex = index
                copy.productIndex = peIndex
                
                console.log(copy)
                return copy
              })
            }}
            onChange={(e) => handleChange(index, peIndex, e.target.name, e.target.value)}
            defaultValue={productEstimate[index].products[peIndex].name}
            readOnly={productEstimate[index].products[peIndex].readOnly}
            autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
          <input
            defaultValue={productEstimate[index].products[peIndex].product_id}
            name={`measurement[${index}].products[${peIndex}].product_id`}
            ref={register}
            autoComplete="off"
            type="hidden" />
        </div>
      </div>
      {/* <div className="col s6 m2 input-fields">
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
      </div> */}
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
        <span className="left width-100 pt-1">Prince un.</span>
        <input
          type="text"
          name={`measurement[${index}].products[${peIndex}].price`}
          ref={register(schema.requiredDecimal)}
          defaultValue={productEstimate[index].products[peIndex].price}
          onChange={(e) => productTotalPrice(index, peIndex, e.target.value)}
          className="product-value price" />
        {errors.price && <span>{errors.price.message}</span>}
      </div>
      <div className="col s6 m2 calc-fields">
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
  )
}

export default ProductEstimate
