import React from 'react'
import moment from 'moment'

const EstimateDetail = ({estimate}) => {
  return (
    <div className="section">
      <div className="card-panel">
        <div className="row">
          <div className="col s5">
            <h6>{estimate.title}</h6>
            <span>{estimate.description}</span>
          </div>
          <div className="col s5">
            <span style={{width: '100%'}} className="left">Customer: {estimate.lead.customer.name}</span>
            <span style={{width: '100%'}} className="left">Location: {estimate.location}</span>
            <span style={{width: '100%'}} className="left">{estimate.category}</span>
          </div>
          <div className="col s2">
            <span className="chip lighten-5 green green-text right mr-0">{estimate.status}</span>
            <span style={{width: '100%'}} className="right right-align">{moment(estimate.created_at).format("MM/DD/YYYY")}</span>
          </div>
        </div>
      </div>
    </div>
  )
}

export default EstimateDetail
