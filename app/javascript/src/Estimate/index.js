import React, { useContext } from 'react'

import EstimateDetail from '../Estimate/EstimateDetail'

import { EstimateContext } from '../context/Estimate';
import ProductEstimateProposal from './ProductEstimateProposal';

const schema = {
  requiredDecimal: { required: true, pattern: /^\d+(\.\d{1,2})?$/ }
}

const ProductComponent = () => {
  const {
    addArea,
    estimate,
    productEstimate,
    remoteSubmit
  } = useContext(EstimateContext)
  
  return (
    <div className="row">
      <div className="col s12">
        <div className="container">
          <a className="btn waves-effect waves-light modal-trigger breadcrumbs-btn right mr-2 indigo border-round btn-send-email"
            href="#modal-areas">See Measurements</a>
          <EstimateDetail />

          <div className="card">
            <div className="card-content">
              <ul className="stepper horizontal stepper-head-only">
                <li className="step">
                  <a href={`/estimates/step_one/${estimate.lead.id}`}>
                    <div className="step-title waves-effect">Step 1</div>
                  </a>
                </li>
                <li className="step ">
                  <a href={`/estimates/${estimate.id}/schedule`}>
                    <div className="step-title waves-effect">Schedule</div>
                  </a>
                </li>
                <li className="step">
                  <a href={`/estimates/${estimate.id}/measurements`}>
                    <div className="step-title waves-effect">Measurements</div>
                  </a>
                </li>
                <li className="step active">
                  <a href={`/estimates/${estimate.id}/products`}>
                    <div className="step-title waves-effect">Itens</div>
                  </a>
                </li>
              </ul>
              
              <ProductEstimateProposal />

              <div className="row mt-1">
                <a onClick={addArea} className="btn btn-add-product-area btn-secondary"><i className="material-icons left">add</i> Add Area Group</a>
              </div>
            </div>

          </div>
        </div>
      </div>
      <div className="col s12 pb-2 pr-0 pl-0" style={{ position: 'relative', zIndex: 1 }}>
        <a className="btn grey lighten-5 grey-text waves-effect waves-light breadcrumbs-btn left save" href='measurements'><i className="material-icons left">arrow_back</i> Back</a>
        <a className="btn indigo waves-effect waves-light breadcrumbs-btn right ml-1" onClick={() => remoteSubmit()}><i className="material-icons left">save</i> Save</a>
      </div>
    </div >
  )
}

export default ProductComponent


