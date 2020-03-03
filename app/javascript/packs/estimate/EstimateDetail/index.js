import React from 'react'
import moment from 'moment'

const EstimateDetail = ({estimate}) => {
  return (
    <div className="section">
      <div className="card-panel">
        <div className="row">
          <div className="col s5">
            <h6>{estimate.data.title}</h6>
            <span>{estimate.data.description}</span>
          </div>
          <div className="col s5">
            <span style={{width: '100%'}} className="left">Customer: {estimate.lead.customer.data.name}</span>
            <span style={{width: '100%'}} className="left">Location: {estimate.data.location}</span>
            <span style={{width: '100%'}} className="left">{estimate.data.category}</span>
          </div>
          <div className="col s2">
            <span className="chip lighten-5 green green-text right mr-0">{estimate.data.status}</span>
            <span style={{width: '100%'}} className="right right-align">{moment(estimate.data.created_at).format("MM/DD/YYYY")}</span>
          </div>
        </div>
      </div>
    </div>
  )
}

export default EstimateDetail
